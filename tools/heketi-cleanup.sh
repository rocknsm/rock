#!/bin/bash
heketi="http://$(kubectl get svc | grep -P '^heketi\s' | awk '{ print $3":"$5 }' | cut -d'/' -f 1)"
keep=$(kubectl get pv | tail -n +2 | awk '{ print $1}' | xargs -I X kubectl describe pv X | grep Path | awk '{ print $2}');
for a in $(heketi-cli -s $heketi volume list | grep -v heketi | awk '{print $3}' | cut -d':' -f 2); do
  found=0;
  for b in $keep; do
    if [ "$a" == "$b" ]; then
      found=1;
      echo "Keeping $a";
    fi;
  done;
  if [ $found -eq 0 ]; then
    echo "Deleteing $a";
    heketi-cli -s $heketi volume delete $(heketi-cli -s $heketi volume list | grep $a | awk '{print $1}' | cut -d':' -f 2);
  fi;
done;
