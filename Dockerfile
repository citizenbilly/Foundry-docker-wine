FROM debian:bookworm
LABEL maintainer="docker@citizenbilly.com"

ARG CONTAINER_GID=10000
ARG CONTAINER_UID=10000

ENV APPID="2915550"
ENV GAME_NAME="Foundry"

ENV HOME "/home/steam"
ENV STEAM_PATH "${HOME}/Steam"
ENV SERVER_DIR="${HOME}/foundry"
ENV ASTEAM_PATH="${STEAM_PATH}/compatibilitytools.d"

ENV GE_PROTON_VERSION="9-4"
ENV GE_PROTON_URL="https://github.com/GloriousEggroll/proton-ge-custom/releases/download/GE-Proton${GE_PROTON_VERSION}/GE-Proton${GE_PROTON_VERSION}.tar.gz"
ENV STEAM_COMPAT_CLIENT_INSTALL_PATH="${STEAM_PATH}/compatibilitytools.d/GE-Proton${GE_PROTON_VERSION}/"
ENV STEAM_COMPAT_DATA_PATH="${STEAM_PATH}/steamapps/compatdata/"

COPY files/ /opt/config/default/

EXPOSE 3724
EXPOSE 27015

RUN groupadd -g $CONTAINER_GID steam \
    && useradd -g $CONTAINER_GID -u $CONTAINER_UID -m steam \
    && sed -i 's#^Components: .*#Components: main non-free contrib#g' /etc/apt/sources.list.d/debian.sources \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        xvfb \
        libgl1-mesa-glx:i386 \
        ca-certificates \
        winbind \
        dbus \
        libfreetype6 \
        wget \
        locales \
        lib32gcc-s1:i386 \
        steamcmd \
    && ln -s /usr/games/steamcmd /usr/bin/steamcmd \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y

RUN chmod +x /opt/config/default/scripts/start-server.sh
RUN chown steam: -R /home/steam
RUN /bin/sh -c echo "* hard nice -20" | tee -a /etc/security/limits.conf

USER steam

RUN mkdir -p "$SERVER_DIR" \
    && mkdir -p "${SERVER_DIR}/savegame" \
    && mkdir -p "${STEAM_PATH}/compatibilitytools.d" \
    && mkdir -p "${STEAM_PATH}/steamapps/compatdata/${STEAM_APP_ID}" \
    && mkdir -p "${HOME}/.steam" \
    && steamcmd +quit \
    && ln -s "${HOME}/.local/share/Steam/steamcmd/linux32" "${HOME}/.steam/sdk32" \
    && ln -s "${HOME}/.local/share/Steam/steamcmd/linux64" "${HOME}/.steam/sdk64" \
    && ln -s "${HOME}/.steam/sdk32/steamclient.so" "${HOME}/.steam/sdk32/steamservice.so" \
    && ln -s "${HOME}/.steam/sdk64/steamclient.so" "${HOME}/.steam/sdk64/steamservice.so"\ 
    && wget "${GE_PROTON_URL}" -O "${HOME}/GE-Proton${GE_PROTON_VERSION}.tgz" \
    && tar -x -C "${STEAM_PATH}/compatibilitytools.d/" -f "${HOME}/GE-Proton${GE_PROTON_VERSION}.tgz"

CMD ["/opt/config/default/scripts/start-server.sh"]