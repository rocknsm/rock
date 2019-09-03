#!/usr/bin/python

import socket
import os
import sys
import logging

# Byte conversion utility for compatibility between
# Python 2 and 3.
# http://python3porting.com/problems.html#nicer-solutions
if sys.version_info < (3,):
    def _b(x):
        return x
else:
    import codecs
    def _b(x):
        return codecs.latin_1_encode(x)[0]


class SystemdNotifier:
    """This class holds a connection to the systemd notification socket
    and can be used to send messages to systemd using its notify method."""

    def __init__(self, debug=False):
        """Instantiate a new notifier object. This will initiate a connection
        to the systemd notification socket.
        Normally this method silently ignores exceptions (for example, if the
        systemd notification socket is not available) to allow applications to
        function on non-systemd based systems. However, setting debug=True will
        cause this method to raise any exceptions generated to the caller, to
        aid in debugging.
        """
        self.debug = debug
        try:
            self.socket = socket.socket(socket.AF_UNIX, socket.SOCK_DGRAM)
            addr = os.getenv('NOTIFY_SOCKET')
            if addr[0] == '@':
                addr = '\0' + addr[1:]
            self.socket.connect(addr)
        except:
            self.socket = None
            if self.debug:
                raise

    def notify(self, state):
        """Send a notification to systemd. state is a string; see
        the man page of sd_notify (http://www.freedesktop.org/software/systemd/man/sd_notify.html)
        for a description of the allowable values.
        Normally this method silently ignores exceptions (for example, if the
        systemd notification socket is not available) to allow applications to
        function on non-systemd based systems. However, setting debug=True will
        cause this method to raise any exceptions generated to the caller, to
        aid in debugging."""
        try:
            self.socket.sendall(_b(state))
        except:
            if self.debug:
                raise


def main(argv):
    import getopt
    timeout = 30
    try:
        opts, args = getopt.getopt(argv[1:],"t",["timeout="])
    except getopt.GetoptError:
        print ('{} [-t|--timeout 10] zookeeper:2181'.format(argv[0]) )
        sys.exit(2)
    for opt, arg in opts:
        if opt in ("-t", "--timeout"):
            timeout = arg
            logging.info("Setting timeout to {} seconds".format(timeout))

    if len(args) == 0:
        print ('ERROR: Zookeeper host and port are required.')
        sys.exit(3)


    host, separator, port = args[0].rpartition(':')

    assert separator # separator (`:`) must be present
    port = int(port) # convert to integer

    n = SystemdNotifier()
    n.notify("STATUS=Connecting to Zookeeper at {}:{}".format(host, port))
    zk_sock = None
    while True:
      try:
          zk_sock = socket.create_connection((host, port), timeout)
          break
      except socket.error:
          logging.error("Connection refused. Trying again...")
      except socket.timeout:
          logging.error("Timeout expired. Trying again...")

    # We're connected. Let's ask zookeeper if it's ready
    zk_sock.send("ruok\n")
    zk_resp = zk_sock.recv(1024)
    if zk_resp != "imok":
        logging.error("Zookeeper up but not healthy: {}".format(zk_resp))
        # 121 == EREMOTEIO
        n.notify("ERRNO=121")
        exit(121)

    n.notify("STATUS=Zookeeper is ready at {}:{}!".format(host, port))
    n.notify("READY=1")

    exit(0)

if __name__ == '__main__':
   import sys
   main(sys.argv)
