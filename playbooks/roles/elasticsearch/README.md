Elasticsearch
=========

Central database for managing all Rock data.

Requirements
------------

Currently none.

Role Variables
--------------

TODO

Dependencies
------------

None

Reading Cluster Health
----------------------
An Elasticsearch cluster can be in one of the three states: GREEN, YELLOW, or RED. If all the shards, meaning primary as well as replicas, are assigned in the cluster, it will be in the GREEN state. If any one of the replica shards is not assigned because of any problem, then the cluster will be in the YELLOW state. If any one of the primary shards is not assigned on a node, then the cluster will be in the RED state. We will see more on these states in the upcoming chapters. Elasticsearch never assigns a primary and its replica shard on the same node.

Dixit, Bharvi. Elasticsearch Essentials (p. 16). Packt Publishing. Kindle Edition.

Templates
------------

4 templates are currently defined; base, detection, file, network, observations

The base template will be applied to ALL indices, even ones no created by the current templates. The base template does a regex search for all string data types that match id_*_h and converts it to an "ip" data type. This is to ensure if there is a log created that is not covered by an existing template, it will still show up when search by an ip. This is currently not done for ports as elastic may default numbers into "long", but if it does not it will be changed to also account for id_*_p.

Elasticsearch terms
--------------------

analysis

    Analysis is the process of converting full text to terms. Depending on which analyzer is used, these phrases: FOO BAR, Foo-Bar, foo,bar will probably all result in the terms foo and bar. These terms are what is actually stored in the index. A full text query (not a term query) for FoO:bAR will also be analyzed to the terms foo,bar and will thus match the terms stored in the index. It is this process of analysis (both at index time and at search time) that allows Elasticsearch to perform full text queries. Also see text and term.
cluster

    A cluster consists of one or more nodes which share the same cluster name. Each cluster has a single master node which is chosen automatically by the cluster and which can be replaced if the current master node fails.
document

    A document is a JSON document which is stored in Elasticsearch. It is like a row in a table in a relational database. Each document is stored in an index and has a type and an id. A document is a JSON object (also known in other languages as a hash / hashmap / associative array) which contains zero or more fields, or key-value pairs. The original JSON document that is indexed will be stored in the _source field, which is returned by default when getting or searching for a document.
id

    The ID of a document identifies a document. The index/id of a document must be unique. If no ID is provided, then it will be auto-generated. (also see routing)
field

    A document contains a list of fields, or key-value pairs. The value can be a simple (scalar) value (eg a string, integer, date), or a nested structure like an array or an object. A field is similar to a column in a table in a relational database. The mapping for each field has a field type (not to be confused with document type) which indicates the type of data that can be stored in that field, eg integer, string, object. The mapping also allows you to define (amongst other things) how the value for a field should be analyzed.
index

    An index is like a table in a relational database. It has a mapping which contains a type, which contains the fields in the index. An index is a logical namespace which maps to one or more primary shards and can have zero or more replica shards.
mapping

    A mapping is like a schema definition in a relational database. Each index has a mapping, which defines a type, plus a number of index-wide settings. A mapping can either be defined explicitly, or it will be generated automatically when a document is indexed.
node

    A node is a running instance of Elasticsearch which belongs to a cluster. Multiple nodes can be started on a single server for testing purposes, but usually you should have one node per server. At startup, a node will use unicast to discover an existing cluster with the same cluster name and will try to join that cluster.
primary shard

    Each document is stored in a single primary shard. When you index a document, it is indexed first on the primary shard, then on all replicas of the primary shard. By default, an index has 5 primary shards. You can specify fewer or more primary shards to scale the number of documents that your index can handle. You cannot change the number of primary shards in an index, once the index is created. See also routing
replica shard

    Each primary shard can have zero or more replicas. A replica is a copy of the primary shard, and has two purposes:

        increase failover: a replica shard can be promoted to a primary shard if the primary fails
        increase performance: get and search requests can be handled by primary or replica shards. By default, each primary shard has one replica, but the number of replicas can be changed dynamically on an existing index. A replica shard will never be started on the same node as its primary shard.

routing

    When you index a document, it is stored on a single primary shard. That shard is chosen by hashing the routing value. By default, the routing value is derived from the ID of the document or, if the document has a specified parent document, from the ID of the parent document (to ensure that child and parent documents are stored on the same shard). This value can be overridden by specifying a routing value at index time, or a routing field in the mapping.
shard

    A shard is a single Lucene instance. It is a low-level “worker” unit which is managed automatically by Elasticsearch. An index is a logical namespace which points to primary and replica shards. Other than defining the number of primary and replica shards that an index should have, you never need to refer to shards directly. Instead, your code should deal only with an index. Elasticsearch distributes shards amongst all nodes in the cluster, and can move shards automatically from one node to another in the case of node failure, or the addition of new nodes.
source field

    By default, the JSON document that you index will be stored in the _source field and will be returned by all get and search requests. This allows you access to the original object directly from search results, rather than requiring a second step to retrieve the object from an ID.
term

    A term is an exact value that is indexed in Elasticsearch. The terms foo, Foo, FOO are NOT equivalent. Terms (i.e. exact values) can be searched for using term queries. See also text and analysis.
text

    Text (or full text) is ordinary unstructured text, such as this paragraph. By default, text will be analyzed into terms, which is what is actually stored in the index. Text fields need to be analyzed at index time in order to be searchable as full text, and keywords in full text queries must be analyzed at search time to produce (and search for) the same terms that were generated at index time. See also term and analysis.
type

    A type used to represent the type of document, e.g. an email, a user, or a tweet. Types are deprecated and are in the process of being removed.

https://www.elastic.co/guide/en/elasticsearch/reference/current/glossary.html#index

Helpful Commands
---------------
curl -XGET 'localhost:9200/_cat/indices?v&pretty'
