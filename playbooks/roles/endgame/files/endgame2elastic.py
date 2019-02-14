from __future__ import print_function
import sys
from elasticsearch import Elasticsearch
from elasticsearch.helpers import scan
from elasticsearch.exceptions import NotFoundError
from kafka import KafkaProducer
import RestResponse
import requests
import json
import urllib
import urlparse
from datetime import datetime, timedelta

class Endgame:
    def url(self, endpoint):
        return self.host + endpoint

    def __init__(self, host, username, password):
        self.host = host
        self.login(username, password)

    def login(self, username, password):
        creds = {
            'username': username,
            'password': password,
        }
        r = requests.post(self.url('/api/v1/auth/login/'), json=creds, verify=False)
        self.token = RestResponse.parse(r.json()).metadata.token
        self.headers = {'Authorization': 'JWT ' + self.token}

    def get(self, endpoint, params={}):
        response_raw = requests.get(self.url(endpoint), params=params, verify=False, headers=self.headers)
        response_json = json.loads(response_raw.text.decode('raw_unicode_escape').encode('ascii', 'replace')) # Unicode causes problems for us
        response = RestResponse.parse(response_json)
        next_endpoint = None
        if response.metadata.next_url:
            cur_path, _, cur_params_raw = urlparse.urlparse(response_raw.url)[2:5]
            cur_params = dict(urlparse.parse_qsl(cur_params_raw))
            new_params = dict(urlparse.parse_qsl(urlparse.urlparse(response.metadata.next_url)[4]))
            cur_params.update(new_params) # Write the EG-provided parameters over existing parameters
            next_endpoint = cur_path + '?' + urllib.urlencode(cur_params)
        return response, next_endpoint

    def collections(self):
        return self.get('/api/v1/collections/', {'per_page': 500})

    def collection(self, id, scope=None, raw=False):
        params = {'per_page': 500}
        if scope:
            params['scope'] = scope
        if raw:
            params['raw'] = True

        return self.get('/api/v1/collections/'+id, params)

# Collection types that we aren't interested in
ignoredTypes = set([
    'policyResponse', # Whenever a new policy is installed
    'endUserNotificationSetupResponse', # The following are all part of the sensor install process
    'hookEngineSetupResponse',
    'loadDriverResponse',
    'sensorInstallResponse',
    'eventLoggingSearchResponse', # This is the data from Artemis queries
])

# Meta data for collection types we are interested in
collectionTypes = {
    'userSessionsSurveyResponse': {'friendly': 'user_session_survey', 'scope': 'user_sessions'},
    'systemSurveyResponse': {'friendly': 'system_survey'},
    'systemNetworkSurveyResponse': {'friendly': 'network_survey', 'scope': 'connections'},
    'kernelModulesSurveyResponse': {'friendly': 'kernel_module_survey', 'scope': 'kernel_modules'},
    'collectAutoRunsResponse': {'friendly': 'autorun_survey', 'scope': 'autoruns_locations'},
    'processSurveyResponse': {'friendly': 'process_survey', 'scope': 'processes'},
    'processSearchResponse': {'friendly': 'process_search', 'scope': 'processes'},
    'windowsFirewallSurveyResponse': {'friendly': 'firewall_rule_survey', 'scope': 'firewall_rules'},
    'softwareSurveyResponse': {'friendly': 'software', 'scope': 'software'},
    'removableMediaSurveyResponse': {'friendly': 'removable_media_survey', 'scope': 'removable_media'},
    'dirwalkResponse': {'friendly': 'dir_walk', 'raw': 'file_list'},
    'registryQueryResponse': {'friendly': 'registry_walk', 'raw': 'values'},
    'registrySearchResponse': {'friendly': 'registry_search', 'raw': 'values'},
    'systemNetworkSearchResponse': {'friendly': 'network_search', 'scope': 'connections'},
    'userSessionsSearchResponse': {'friendly': 'user_sessions_search', 'scope': 'user_sessions'},
    'fileSearchResponse': {'friendly': 'dir_search', 'raw': 'file_list'},
    'downloadFileResponse': {'friendly': 'download_file'},
}

class Endgame2Elastic:
    def __init__(self, host, username, password):
        self.api = Endgame(host, username, password)
        self.most_recent_collection = datetime.min
        self.ids_already_stored = set()
        self.no_earlier_than = None

    @staticmethod
    def parseDate(txt):
        for fmt in ('%Y-%m-%dT%H:%M:%SZ', '%Y-%m-%dT%H:%M:%S.%fZ'):
            try:
                return datetime.strptime(txt, fmt)
            except ValueError:
                pass
        raise ValueError('no valid date format found')

    def prepareForDelta(self, es):
        try:
            response = es.get(index='endgame-meta', doc_type='doc', id='last_update') # Raises NotFoundError if index doesn't exist, which we ignore
        except NotFoundError:
            return

        metadata = RestResponse.parse(response)
        self.no_earlier_than = datetime.strptime(metadata._source.dt, '%Y-%m-%dT%H:%M:%S') - timedelta(days=1)

        query = {
            'query': {
                'range': {
                    'timestamp': {'gte': self.no_earlier_than}
                }
            },
            '_source': 'collection_id'
        }
        for r in scan(es, query=query, index='endgame*'):
            self.ids_already_stored.add(r['_source']['collection_id'])

    def saveForDelta(self, es):
        if self.most_recent_collection > datetime.min:
            es.index(index='endgame-meta', doc_type='doc', id='last_update', body={'dt': self.most_recent_collection})

    def getCollection(self, id, timestamp, typ):
        scope = None
        raw = 'raw' in collectionTypes[typ]
        if 'scope' in collectionTypes[typ]:
            scope = collectionTypes[typ]['scope']

        collection, next_endpoint = self.api.collection(id, scope, raw)
        hostname = collection.data.endpoint.hostname

        while True:
            results = collection.data.data.results
            if raw:
                results = collection.data.pop(collectionTypes[typ]['raw'])

            if not results: # Empty collection
                break

            for r in results:
                r.hostname = hostname
                r.timestamp = timestamp
                r.collection_type = collectionTypes[typ]['friendly']
                r.collection_id = id
                yield r

            if not next_endpoint:
                break
            collection, next_endpoint = self.api.get(next_endpoint)

    def getCollections(self):
        response, next_endpoint = self.api.collections()
        while True:
            for collection_info in response.data:
                typ = collection_info.type
                id = collection_info.id
                timestamp = self.parseDate(collection_info.created_at)

                if self.most_recent_collection < timestamp:
                    self.most_recent_collection = timestamp

                if self.no_earlier_than and timestamp < self.no_earlier_than: # Reached the time limit, break the loop
                    next_endpoint = None
                    break

                if id in self.ids_already_stored:
                    continue
                if typ in ignoredTypes:
                    continue
                if typ not in collectionTypes:
                    print('Unknown type: ' + typ)
                    continue

                for r in self.getCollection(id, timestamp, typ):
                    yield r

            if not next_endpoint:
                break
            response, next_endpoint = self.api.get(next_endpoint)

def toUrl(str):
    if str[:4] == 'http':
        return str
    return 'https://' + str

if len(sys.argv) != 5:
    print("usage: endgame2elastic.py elastic_url endgame_url endgame_username endgame_password")
    sys.exit()

kafka = KafkaProducer(bootstrap_servers=['kafka.default.svc.cluster.local:9092'], value_serializer=lambda m: json.dumps(m).encode('ascii'))
es = Elasticsearch(sys.argv[1])
eg = Endgame2Elastic(toUrl(sys.argv[2]), sys.argv[3], sys.argv[4])
eg.prepareForDelta(es)
for r in eg.getCollections():
    kafka.send('endgame-raw', r)
eg.saveForDelta(es)
kafka.flush()
