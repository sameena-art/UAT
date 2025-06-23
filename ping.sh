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

echo ""
echo ""

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

echo ""
echo ""

# Thresholds (adjust as needed)
CPU_WARN_THRESHOLD=1.5  # Load average threshold
MEM_WARN_THRESHOLD=80   # % memory usage

echo "📊 System Resource Report - $(date)"
echo "--------------------------------------"

# CPU Load (1, 5, 15 min)
LOAD=$(uptime | awk -F 'load average: ' '{ print $2 }')
LOAD_1MIN=$(echo $LOAD | cut -d',' -f1)

echo "🧠 CPU Load Average (1, 5, 15 min): $LOAD"

# Check if load is too high (1-minute average)
LOAD_VALUE=$(printf "%.1f\n" "$LOAD_1MIN")
if (( $(echo "$LOAD_VALUE > $CPU_WARN_THRESHOLD" | bc -l) )); then
    echo "⚠️  High CPU Load: $LOAD_VALUE (Threshold: $CPU_WARN_THRESHOLD)"
else
    echo "✅ CPU Load is normal"
fi

echo "--------------------------------------"

# RAM Usage
MEM_INFO=$(free -m | grep Mem)
TOTAL_MEM=$(echo $MEM_INFO | awk '{print $2}')
USED_MEM=$(echo $MEM_INFO | awk '{print $3}')
MEM_PERCENT=$(( USED_MEM * 100 / TOTAL_MEM ))

echo "💾 RAM Usage: $USED_MEM MiB / $TOTAL_MEM MiB (${MEM_PERCENT}%)"

if [ "$MEM_PERCENT" -ge "$MEM_WARN_THRESHOLD" ]; then
    echo "⚠️  High Memory Usage: ${MEM_PERCENT}% (Threshold: $MEM_WARN_THRESHOLD%)"
else
    echo "✅ Memory usage is normal"
fi

echo "--------------------------------------"

#!/bin/bash

echo "👥 Currently Logged-In Users on $(hostname)"
echo "--------------------------------------------"

# List currently logged-in users with their login info
who

# Optionally show user sessions with more detail
echo ""
echo "📋 Detailed Session Info:"
