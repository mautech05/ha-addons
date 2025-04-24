#!/usr/bin/env bash
# shellcheck shell=bash disable=SC2016
set -e

# Load bashio
source /usr/lib/bashio/bashio.sh

# Add-On banner on Startup
bashio::log.blue '-----------------------------------------------------------'
bashio::log.blue " Add-on: $(bashio::addon.name)"
bashio::log.blue " $(bashio::addon.description)"
bashio::log.blue '-----------------------------------------------------------'
bashio::log.green ' Provided by: https://github.com/mautech05/ha-addons '
bashio::log.blue '-----------------------------------------------------------'

# Startup Timestamp
echo "### Starting Kopia server on $(date '+%Y-%m-%d %H:%M:%S')"

# Default values (fallbacks)
DEFAULT_WEBUI_PASSWORD="homeassistant"
DEFAULT_REPO_PASSWORD="homeassistant"

# Read settings using Bashio
CONFIG_PATH=/data/options.json

WEBUI_PASSWORD="$(bashio::config 'webui_password')"
REPO_PASSWORD="$(bashio::config 'repo_password')"
CERTFILE="$(bashio::config 'certfile')"
KEYFILE="$(bashio::config 'keyfile')"
if bashio::config.true 'ssl'; then
    SSL_ENABLED="true"
else
    SSL_ENABLED="false"
fi

# Fallback to defaults if needed
if bashio::var.is_empty "$WEBUI_PASSWORD"; then
    bashio::log.warning "webui_password not found in config, using default = $DEFAULT_WEBUI_PASSWORD"
    WEBUI_PASSWORD="$DEFAULT_WEBUI_PASSWORD"
else
    bashio::log.info "Custom WebUI Password detected. Overriding defaults."
fi

if bashio::var.is_empty "$REPO_PASSWORD"; then
    bashio::log.warning "repo_password not found in config, using default = $DEFAULT_REPO_PASSWORD"
    REPO_PASSWORD="$DEFAULT_REPO_PASSWORD"
else
    bashio::log.info "Custom Repo Password detected. Overriding defaults."
fi

# Export environment variables
export KOPIA_PASSWORD="$REPO_PASSWORD"
export KOPIA_SERVER_CONTROL_PASSWORD="$WEBUI_PASSWORD"

# Build SSL options
KOPIA_TLS_OPTIONS=""
if [ "$SSL_ENABLED" = "true" ]; then
    bashio::log.info "SSL is enabled. Starting Kopia with TLS."
    KOPIA_TLS_OPTIONS="--tls-cert-file=/ssl/$CERTFILE --tls-key-file=/ssl/$KEYFILE"
else
    bashio::log.warning "SSL is disabled. Starting Kopia in insecure mode."
    KOPIA_TLS_OPTIONS="--insecure"
fi

# Start Kopia server
exec kopia server start \
    --address=0.0.0.0:51515 \
    $KOPIA_TLS_OPTIONS \
    --server-control-username="kopia" \
    --server-control-password="$KOPIA_SERVER_CONTROL_PASSWORD" \
    --server-username="kopia" \
    --server-password="$KOPIA_PASSWORD"
