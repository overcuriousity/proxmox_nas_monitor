#!/bin/bash

# IP Address of the NAS
NAS_IP="10.10.10.10"

# Container IDs
CONTAINERS=(123 456 789)

# Function to start containers
start_containers() {
    for ct in "${CONTAINERS[@]}"; do
        if [ "$(/usr/sbin/pct status "$ct" | grep -c 'stopped')" -eq 1 ]; then
            echo "Starting container $ct"
            /usr/sbin/pct start "$ct"
        fi
    done
}

# Function to stop containers
stop_containers() {
    for ct in "${CONTAINERS[@]}"; do
        if [ "$(/usr/sbin/pct status "$ct" | grep -c 'running')" -eq 1 ]; then
            echo "Stopping container $ct"
            /usr/sbin/pct shutdown "$ct" --forceStop 1
        fi 
    done
}


# Check NAS connectivity
PING_SUCCESS=$(ping -c 5 "$NAS_IP" | grep 'received' | awk -F',' '{ print $2 }' | awk '{ print $1 }')

if [ "$PING_SUCCESS" -ge 4 ]; then
    echo "NAS is reachable. Ensuring containers are started."
    start_containers
else
    echo "NAS is not reachable. Shutting down containers."
    stop_containers
fi
