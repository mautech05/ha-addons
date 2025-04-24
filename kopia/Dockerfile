#################
# 1 Build Image #
#################
ARG BUILD_FROM=kopia/kopia
ARG BUILD_VERSION
FROM ${BUILD_FROM}

##################
# 2 Modify Image #
##################

# Set S6 wait time
ENV S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_SERVICES_GRACETIME=0

# Environment variables
ENV DEBIAN_FRONTEND="noninteractive" \
    TERM="xterm-256color" \
    LC_ALL="C.UTF-8" \
    KOPIA_PASSWORD="Mx9tvCWfOcy2" \
    KOPIA_SERVER_CONTROL_PASSWORD="Mx9tvCWfOcy2" \
    KOPIA_CACHE_DIRECTORY="/app/cache" \
    KOPIA_CHECK_FOR_UPDATES="false" \
    KOPIA_CONFIG_PATH="/app/config/repository.config" \
    KOPIA_LOG_DIR="/app/logs" \
    KOPIA_PERSIST_CREDENTIALS_ON_CONNECT="false" \
    RCLONE_CONFIG="/app/rclone/rclone.conf"

# Kopia specifics + Bashio
RUN apt-get update && \
    apt-get upgrade -y --with-new-pkgs && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    jq \
    bash && \
    # Install Bashio
    BASHIO_VERSION="0.16.4" && \
    mkdir -p /tmp && \
    mkdir -p /tmp/bashio && \
    curl -fsSL "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" | tar -xzf - --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio && \
    rm -rf /tmp/bashio && \
    # Clean up
    apt-get clean autoclean -y && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/* \
    /var/tmp/* /usr/share/doc/ /usr/share/man/ /usr/share/locale/ \
    /root/.cache /root/.local /root/.gnupg /root/.config /tmp/*

##################
# 3 Install apps #
##################
COPY run.sh /
RUN chmod a+x /run.sh

################
# 4 Entrypoint #
################

WORKDIR /
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["/run.sh"]
