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
