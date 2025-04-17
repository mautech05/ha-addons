#!/bin/bash

# Get addon settings from HA
CONFIG_PATH=/data/options.json

# Read settings file
if [ -f "$CONFIG_PATH" ]; then
    if jq -e '.password' $CONFIG_PATH > /dev/null 2>&1; then
        PASSWORD=$(jq -r '.password' $CONFIG_PATH)
    else
        PASSWORD="homeassistant"
    fi
else
    # Default values
    PASSWORD="homeassistant"
fi

# Export Kopia Environment Variables
export KOPIA_PASSWORD="$PASSWORD"
export KOPIA_SERVER_CONTROL_PASSWORD="$PASSWORD"

# Start Kopia
echo "Starting Kopia server..."
exec kopia server start --address=0.0.0.0:51515 --insecure --server-control-username="kopia" --server-username="kopia" --server-control-password="$KOPIA_PASSWORD" --server-password="$KOPIA_PASSWORD"