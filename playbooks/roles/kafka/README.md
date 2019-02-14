## Monitoring Kafka/Zookeeper using Kafka Manager GUI
### Navigate to kafka-manager web gui 
1. If you are using master-server as dns, Open browser navigate to http://kafka-manager.
2. If you are not using master as dns, Open Browser and navigate to kafka-manager service ip.
    - To get the service ip do the following:
        - ssh to master-server and 
        - run kubectl get services | grep -i kafka-manager
        - Get the external ip address of the kafka-manager service
### Adding a cluster
1. Select Cluster-> "Add Cluster"
2. Fill out Add cluster form:
	* "Cluster Name" - Name your cluster ie: "zk"
	- "Cluster Zookeeper Hosts"
		- For the default zookeeper cluster use "zookeeper:2181"
        - For remote sensor zookeeper use the kafka broker service name for the node the format will be "kakfa-<node shortname>-broker" and port 2181 ie: "kafka-tfsensor2-broker:2181"
	- Check "Enable JMX Polling"
	- Check "Poll consumer information"
3. Press "Save" at the bottom

### View Kafka Stats
(Note: You must first add a cluster, see section "Adding a cluster")
1. Select "Cluster->List"
2. Select the desired zookeeper cluster to view.
3. To view the combined stats of all topics:
    - Under Summary section, Select the number next to "Brokers".
4. To view individual stats for each topic:
    - Under Summary section, Select the number next to "Topics"
    - Then select the desired topic name to view ie: bro-raw
