#!/usr/bin/env bash

host="$1"
port="$2"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') | $1" >> logs/network-check.log
}

#Arguement validation
if [[ "$#" -lt 1 || "$#" -gt 2 ]]
then
    echo "Usage: ./network-check.sh <hostname-or-ip> [port]"
    exit 2
fi


echo "Host: $host"
echo "Port: ${port:-Not specified}"


#Validate host
resolved_address=$(getent ahosts "$host" | awk 'NR==1 {print $1}')

if [[ -z "$resolved_address" ]]
then
    echo "Unable to resolve host: $host"
    log "Network check | Host=$host | Status=UNRESOLVED"
    exit 2
fi

echo "Resolved address: $resolved_address"
log "Network check | Host=$host | Address=$resolved_address | Status=RESOLVED"


#Connectivity test ping check
if ! ping -c 1 "$host" > /dev/null 2>&1
then
    echo "Host is not reachable: $host"
    exit 1
fi
echo "Host is reachable."
log "Network check | Host=$host | Status=REACHABLE"


#Network interface
echo "Network interfaces:"
ip -brief address

#Port validation
if [[ -n "$port" ]]
then
    if [[ ! "$port" =~ ^[0-9]+$ ]]
    then
        echo "Invalid port: enter a number."
        exit 2
    fi

    if [[ "$port" -lt 1 || "$port" -gt 65535 ]]
    then
        echo "Invalid port: enter a number from 1 to 65535."
        exit 2
    fi


 #TCP port check
 if nc -z -w 3 "$host" "$port" > /dev/null 2>&1
 then
    echo "TCP port $port is reachable on $host."
    log "Network check | Host=$host | Port=$port | Status=PORT_REACHABLE"
 else
    echo "TCP port $port is not reachable on $host."
    log "Network check | Host=$host | Port=$port | Status=PORT_UNREACHABLE"
    exit 1
 fi
fi


