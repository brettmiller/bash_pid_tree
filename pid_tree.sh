#!/bin/bash
#
# Display the parent process tree for a given process

M_PPID=$(sudo ss --packet -apn | grep users: | cut -d, -f2)
#M_PPID=$1

COUNT=0

while [ "$M_PPID" != "1" ] ; do
  #WPID_INFO=($( ps -p $M_PPID -o pid= -o ppid= -o ruser= -o cmd= ))
  WPID_INFO="$( ps -p $M_PPID -o pid= -o ppid= -o ruser= -o cmd= )"
  #WPID_INFO="$( ps -p "$M_PPID" --no-headers -o "%p;%P;%a;%u")"
  PID_INFO=(${WPID_INFO})
  M_PPID="${PID_INFO[1]}"
  PROC_LIST[${COUNT}]="${PID_INFO[3]},${PID_INFO[0]},${PID_INFO[2]}"
  let COUNT=$COUNT+1
done

PROC_TREE=''
while [ $COUNT -ge 0 ] ; do
  PROC_TREE="${PROC_TREE}${PROC_LIST[${COUNT}]} ->"
  let COUNT=$COUNT-1
done

# Strip leading and trailing '->'
PROC_TREE=${PROC_TREE# ->}
PROC_TREE=${PROC_TREE%->}
echo "$PROC_TREE"
