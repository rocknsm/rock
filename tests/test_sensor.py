# This contains all the tests that should check to make sure all the services are working together.
# The glue that holds it all together and binds it.

from __future__ import absolute_import, division, print_function
from builtins import (ascii, bytes, chr, dict, filter, hex, input,
                      int, map, next, oct, open, pow, range, round,
                      str, super, zip)
import pytest
import yaml
import json

with open('tests/vars/sensor.vars', 'r') as f:
    try:
        yml_vars = yaml.load(f)
    except yaml.YAMLError as e:
        print(e)

@pytest.mark.parametrize("group_id", yml_vars.get('kafka_groups'))
def test_connection_to_kafka(host, group_id):
    results = host.run('/opt/kafka/bin/kafka-consumer-groups.sh '
                         '--bootstrap-server {host}:{p} '
                         '--describe --group {gid}'.format(host='localhost', p='9092', gid=group_id))
    assert 'Error:' not in results.stdout


def test_logstash_connection_to_elasticsearch(host):
    result = host.run('curl {host}:{p}/_node/stats/pipelines/main'.format(host='localhost', p='9600'))
    result = json.loads(result.stdout)
    assert result['pipelines']['main']['events']['out'] != '0'