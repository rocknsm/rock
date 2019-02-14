# HOW TO USE:
# Drop files you want synchronized to all sensors in the bro/suricata 'all' folders.
# Only __load__.bro (Bro) and custom.rules (Suricata) are loaded by default.
# If you are dropping additonal files, you'll need to load them yourself.
# You can name a folder after the name of a sensor and those files will only be
# dropped on that sensor. Ex: bro/sensor1.lan/test.bro.

from __future__ import print_function
import os
from subprocess import Popen, PIPE
import time

src = '/opt/tfplenum/rulesync/%s/%s/.'
dst = '/opt/tfplenum/%s/custom'

def wait_all(procs):
    while procs:
        time.sleep(1)
        for proc in procs:
            ret = proc.poll()
            if ret is None:
                pass
            elif ret != 0:
                raise Exception("Failed!")
            else:
                procs.remove(proc)

get_nodes = Popen(['/usr/bin/kubectl', 'get', 'nodes', '--show-labels'], stdout=PIPE)
get_pods = Popen(['/usr/bin/kubectl', 'get', 'pods'], stdout=PIPE)

get_nodes.wait()
outs, errs = get_nodes.communicate()
nodes = outs.split("\n")[1:-1]

get_pods.wait()
outs, errs = get_pods.communicate()
pods = [pod.split()[0] for pod in outs.split("\n")[1:-1]]

bros = map(lambda node: node.split()[0], filter(lambda node: "bro=true" in node, nodes))
suricatas = map(lambda node: node.split()[0], filter(lambda node: "suricata=true" in node, nodes))

# Remove existing rules from sensors
procs = [
    Popen(['ssh', sensor, 'rm -rf %s/*' % (dst % 'bro')])
    for sensor in bros
]
procs += [
    Popen(['ssh', sensor, 'rm -rf %s/*' % (dst % 'suricata')])
    for sensor in suricatas
]
wait_all(procs)

# Copy default rules onto sensors
procs = [
    Popen(['scp', '-rq', src % ('bro', 'all'), '%s:%s' % (sensor, dst % 'bro')])
    for sensor in bros
]
procs += [
    Popen(['scp', '-rq', src % ('suricata', 'all'), '%s:%s' % (sensor, dst % 'suricata')])
    for sensor in suricatas
]
wait_all(procs)

# Copy sensor-specific rules
procs = [
    Popen(['scp', '-rq', src % ('bro', sensor), '%s:%s' % (sensor, dst % 'bro')])
    for sensor in bros
    if os.path.exists(src % ('bro', sensor))
]
procs += [
    Popen(['scp', '-rq', src % ('suricata', sensor), '%s:%s' % (sensor, dst % 'suricata')])
    for sensor in suricatas
    if os.path.exists(src % ('suricata', sensor))
]
wait_all(procs)

# Reload rules
procs = [
    Popen(['kubectl', 'exec', '-t', pod, '--', '/usr/local/bro-2.6.1/bin/broctl',  'restart'])
    for pod in pods
    if "bro" in pod
]
procs += [
    Popen(['kubectl', 'exec', '-t', pod, '--', '/usr/bin/suricatasc',  '-c', 'reload-rules'])
    for pod in pods
    if "suricata" in pod and "bootstrap" not in pod
]
wait_all(procs)
