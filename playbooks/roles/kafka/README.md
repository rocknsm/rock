Kafka
=========

Kafka receives data in our build from Suricata and Bro. Suricata pushes it via filebeats to Kafka and Bro pushes it via a custom plugin.

Requirements
------------

Currently none.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

This must be installed with the zookeeper role.

Helpful Kafka Commands
----------------------

Get a list of topics:
docker exec -it rock-kafka /opt/kafka/bin/kafka-topics.sh --zookeeper rock-zookeeper:2181 --list

List information regarding a specific topic
docker exec -it rock-kafka /opt/kafka/bin/kafka-topics.sh --zookeeper rock-zookeeper:2181 --describe --topic suricata-raw

Helpful information
-------------------

What is a Kafka cluster?
************************
A Kafka cluster is one or more Kafka servers.

What is a Kafka producer?
*************************
A Kafka producer is any process that pushes data into Kafka topics within the broker.

What is a Kafka consumer?
*************************
Consumers can read messages starting from a specific offset and are allowed to read from any offset point they choose. This allows consumers to join the cluster at any point in time.

Consumers can join a group called a consumer group. A consumer group includes the set of consumer processes that are subscribing to a specific topic. Each consumer in the group is assigned a set of partitions to consume from. They will receive messages from a different subset of the partitions in the topic. Kafka guarantees that a message is only read by a single consumer in the group.

Consumers pull messages from topic partitions. Different consumers can be responsible for different partitions. Kafka can support a large number of consumers and retain large amounts of data with very little overhead. By using consumer groups, consumers can be parallelised so that multiple consumers can read from multiple partitions on a topic, allowing a very high message processing throughput. The number of partitions impacts the maximum parallelism of consumers as you cannot have more consumers than partitions.

Data/messages are never pushed out to consumers, the consumer will ask for messages when the consumer is ready to handle the message. The consumers will never overload themselves with lots of data or loose any data since all messages are being queued up in Kafka. If the consumer is behind while processing messages, it has the option to eventually catch up and get back to handle data in real time.

What is a broker?

What is a Kafka topic?
**********************
A Topic is a category/feed name to which messages are stored and published. Messages are byte arrays that can store any object in any format. Messages published to the cluster will stay in the cluster until a configurable retention period has passed by. Kafka retains all messages for a set amount of time, and therefore, consumers are responsible to track their location.

Kafka topic partition
*********************
Kafka topics are divided into a number of partitions, which contains messages in an unchangeable sequence. Each message in a partition is assigned and identified by its unique offset. A topic can also have multiple partition logs like the click-topic has in the image to the right. This allows for multiple consumers to read from a topic in parallel.

Kafka Replication
*****************
In Kafka, replication is implemented at the partition level. The redundant unit of a topic partition is called a replica. Each partition usually has one or more replicas meaning that partitions contain messages that are replicated over a few Kafka brokers in the cluster. It's possible for the producer to attach a key to the messages and tell which partition the message should go to. All messages with the same key will arrive at the same partition.

Partitions allow you to parallelize a topic by splitting the data in a particular topic across multiple brokers.

Every partition (replica) has one server acting as a leader and the rest of them as followers. The leader replica handles all read-write requests for the specific partition and the followers replicate the leader. If the leader server fails, one of the follower servers become the leader by default. When a producer publishes a message to a partition in a topic, it is forwarded to its leader. The leader appends the message to its commit log and increments its message offset. Kafka only exposes a message to a consumer after it has been committed and each piece of data that comes in will be stacked on the cluster.


Helpful Tutorials
-----------------
https://www.cloudkarafka.com/blog/2016-11-30-part1-kafka-for-beginners-what-is-apache-kafka.html

License
-------

BSD

Author Information
------------------

Grant Curell wrote this version of the Kafka plugin. grant.curell@salientcrgt.com
