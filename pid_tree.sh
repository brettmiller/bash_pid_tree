#!/bin/bash
#
# Display the parent process tree for a given process


pidtree () {
  M_PPID=$1
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

  PID_TREE=''
  while [ $COUNT -ge 0 ] ; do
    PID_TREE="${PID_TREE}${PROC_LIST[${COUNT}]} ->"
    let COUNT=$COUNT-1
  done

  # Strip leading and trailing '->'
  PID_TREE=${PID_TREE# ->}
  PID_TREE=${PID_TREE%->}
  echo "$PID_TREE"
}

pidtree $1
