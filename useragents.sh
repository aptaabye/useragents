#!/bin/bash

#Desc: read through log looking for unknown user agents
#Usage: ./useragents.sh -f inputfile -s hostsfile

function mismatch () {
        local -i i
        for((i=0;i<$KNSIZE; i++))
        do
                [[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1
        done
        return 0
}

readarray -t KNOWN < "useragents.txt" 
KNSIZE=${#KNOWN[@]}

awk -F'"' '{print $1, $6}' | \
while read ipaddr dash1 dash2 dtstamp delta useragent
do
        if mismatch "$useragent"
        then
                echo "anomaly: $ipaddr $useragent"
        fi
done 

