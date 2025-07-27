#!/bin/bash

set -eu

SERVICES="./files/07-services/services.txt"
TIMERS="./files/07-services/timers.txt"

if [ ! -f "$SERVICES" ]; then
    echo "services.txt not found."
    echo "Exiting..."
    exit 1
fi
if [ ! -f "$TIMERS" ]; then
    echo "timers.txt not found."
    echo "Exiting..."
    exit 1
fi

echo "Enabling services"
while IFS= read -r service ; do
    systemctl enable "$service"
done < "$SERVICES"

echo "Enabling timers"
while IFS= read -r timer ; do
    systemctl enable "$timer"
done < "$TIMERS"
