#!/bin/bash

# Set the server address (hostname or IP)
SERVER="localhost"  # Replace with the actual server address

# Ping the server (1 attempt, wait max 5 seconds)
ping -c 1 -W 5 "$SERVER" > /dev/null 2>&1

# Check the exit status of ping
if [ $? -eq 0 ]; then
    echo "✅ Server $SERVER is UP"
else
    echo "❌ Server $SERVER is DOWN"
fi
THRESHOLD=80

# Get disk usage excluding tmpfs and udev
df -h --output=target,pcent | grep -vE '^Mounted|tmpfs|udev' | while read line; do
    MOUNT=$(echo $line | awk '{print $1}')
    USAGE=$(echo $line | awk '{print $2}' | tr -d '%')

    if [ "$USAGE" -ge "$THRESHOLD" ]; then
        echo "⚠️ Warning: Disk usage on $MOUNT is at ${USAGE}%"
    else
        echo "✅ OK: Disk usage on $MOUNT is at ${USAGE}%"
    fi
done
