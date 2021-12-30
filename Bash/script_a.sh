#!/bin/bash
function help {
  echo 'The --all key displays the IP addresses and symbolic names of all hosts in the current subnet.'
  echo 'The --target key displays a list of open system TCP ports.'
}

function all {
  cat /etc/hosts | grep '^1'
}

function target {
  sudo netstat -tulpn | grep LISTEN
}

if [ $# -eq 0 ]
then
  help
elif [ "$1" == '--target' ]
then
  target
elif [ "$1" == '--all' ]
then
  all
else
  echo 'Please, start script without pararmeters! You will get info about script.'
fi
