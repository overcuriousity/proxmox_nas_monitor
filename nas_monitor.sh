#!/bin/bash

# IP Address of the NAS
NAS_IP="192.168.178.211"

# Container IDs
CONTAINERS=(114 115 116 201)

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
        echo "Stopping container $ct"
        /usr/sbin/pct shutdown "$ct"
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
