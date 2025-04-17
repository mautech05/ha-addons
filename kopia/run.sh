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

# NGINX Reverse Proxy for Ingress
cat > /etc/nginx/http.d/kopia.conf << EOF
server {
    listen 8099;
    
    location / {
        proxy_pass http://127.0.0.1:51515;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        # Para WebSockets
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

# Start Nginx
nginx

# Start Kopia
echo "Starting Kopia server..."
exec kopia server start --address=0.0.0.0:51515 --insecure --server-control-username="kopia" --server-username="kopia" --server-control-password="$KOPIA_PASSWORD" --server-password="$KOPIA_PASSWORD"

# Keep the script alive
wait