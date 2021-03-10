#!/bin/bash

ARG2=$2
COUNT=1

function listPrint {
  cat servers_list | while read LINE
    do 
      echo "Server $COUNT is: $LINE"
      COUNT=$(($COUNT+1))
  done
}

function listWorker {
  cat servers_list | while read LINE
    do
      cat variables_file | while read COM
        do
          ssh $LINE $COM &
      done
  done
}

function allUppercase {
  echo ${ARG2^^}
}

function allLowercase {
  echo ${ARG2,,}
}

function arr {
  array=($(grep SENT variables_file | sed s'/SENT=//' | sed s'/\"//g'))
  echo ${array[0]}
  local COUNT=${#array[*]}
  echo ${array[$COUNT-1]}
}

function rewriteRecord {
  local CHECK=$(grep "SENT" variables_file)
  sed -i "s/$CHECK/SENT=\"$ARG2\"/" variables_file
  echo "Entry changed!"
}

function printHelp {
  echo -e "   --help                            Shows help \n \
  --list                            Print servers addresses from servers_list \n \
  --work                            Executes commands from variables_file for servers in servers_list \n \
  --up [PARAMETER]                  Converts input string to all uppercase \n \
  --low [PARAMETER]                 Converts input string to all lowercase \n \
  --arr                             Print array from special variable
   --rw [PARAMETER]                  Replace array variable"
}

case $1 in
  --help) printHelp;;
  --list) listPrint;;
  --work) listWorker;;
  --up) allUppercase;;
  --low) allLowercase;;
  --arr) arr;;
  --rw) rewriteRecord;;
  *) echo "Try './netscript.sh --help' for more information.";;
esac