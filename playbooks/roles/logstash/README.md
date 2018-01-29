# kubernetes-elk-cluster
**ELK** (**Elasticsearch** + **Logstash** + **Kibana**) cluster on top of **Kubernetes**, made easy.

Here you will find:
* Kubernetes pod descriptor that joins Elasticsearch client-node container with Logstash container (for `localhost` communication)
* Kubernetes pod descriptor that joins Elasticsearch client-node container with Kibana container (for `localhost` communication)
* Kubernetes service descriptor that publishes Logstash
* Kubernetes service descriptor that publishes Kibana

## Pre-requisites

* Kubernetes 1.1.x cluster (tested with 4 nodes [Vagrant + CoreOS](https://github.com/pires/kubernetes-vagrant-coreos-cluster))
* `kubectl` configured to access your cluster master API Server
* Elasticsearch cluster deployed - you can skip deploying `client-nodes` provisioning, since those will be paired with Logstash and Kibana containers, and automatically join the cluster you've assembled with [my Elasticsearch cluster instructions](https://github.com/pires/kubernetes-elasticsearch-cluster)).

## Deploy

The current Logstash configuration is expecting [`logstash-forwarder`](https://github.com/pires/docker-logstash-forwarder) (Lumberjack secure protocol) to be its log input and the certificates provided are valid only for `logstash.default.svc.cluster.local`.
I **highly** recommend you to rebuild your Logstash images with your own configuration and keys, if any.

**Attention:**
* If you're looking for details on how `quay.io/pires/docker-elasticsearch-kubernetes` images are built, take a look at [my other repository](https://github.com/pires/docker-elasticsearch-kubernetes).
* If you're looking for details on how `quay.io/pires/docker-logstash` image is built, take a look at [my Logstash repository](https://github.com/pires/docker-logstash).
* If you're looking for details on how `quay.io/pires/docker-logstash-forwarder` image is built, take a look at [my docker-logstash-forwarder repository](https://github.com/pires/docker-logstash-forwarder).
* If you're looking for details on how `quay.io/pires/docker-kibana` image is built, take a look at [my Kibana repository](https://github.com/pires/docker-kibana).

Let's go, then!

```
kubectl create -f service-account.yaml
kubectl create -f logstash-service.yaml
kubectl create -f logstash-controller.yaml
kubectl create -f kibana-service.yaml
kubectl create -f kibana-controller.yaml
```

Wait for provisioning to happen and then check the status:

```
$ kubectl get pods
NAME              READY     STATUS    RESTARTS   AGE
es-client-s1qnq   1/1       Running   0          57m
es-data-khoit     1/1       Running   0          56m
es-master-cfa6g   1/1       Running   0          1h
kibana-w0h9e      1/1       Running   0          2m
kube-dns-pgqft    3/3       Running   0          1h
logstash-9v8ro    1/1       Running   0          4m
```

As you can assert, the cluster is up and running. Easy, wasn't it?

## Access the service

*Don't forget* that services in Kubernetes are only acessible from containers within the cluster by default, unless you have provided a `LoadBalancer`-enabled service.

```
$ kubectl get service kibana
NAME      LABELS                      SELECTOR                    IP(S)           PORT(S)
kibana    component=elk,role=kibana   component=elk,role=kibana   10.100.187.62   80/TCP
```

You should know what to do from here.