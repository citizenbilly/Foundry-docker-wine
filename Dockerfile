FROM debian:bookworm-slim
LABEL maintainer="docker@citizenbilly.com"

ENV STEAM_HOME="/home/steam"
ENV STEAM_PATH="${STEAM_HOME}/Steam"
ENV SERVER_DIR="${STEAM_HOME}/foundry"

ENV SERVER_NAME="FoundryServer"
ENV WORLD_NAME="FoundryProton"
ENV SERVER_PASSWORD="docker"
ENV GAME_PORT="3724"
ENV QUERY_PORT="27015"
ENV SERVER_IS_PUBLIC="false"
ENV SERVER_SLOTS="16"
ENV MAP_SEED="42938743982"
ENV PAUSE_WHEN_EMPTY="flase"
ENV AUTOSAVE_INT="300"

ARG CONTAINER_GID=10000
ARG CONTAINER_UID=10000

ENV APPID="2915550"
ENV GAME_NAME="Foundry"

RUN groupadd -g $CONTAINER_GID steam \
    && useradd -g $CONTAINER_GID -u $CONTAINER_UID -m steam \
    && sed -i 's#^Components: .*#Components: main non-free contrib#g' /etc/apt/sources.list.d/debian.sources \
    && echo steam steam/question select "I AGREE" | debconf-set-selections \
    && echo steam steam/license note '' | debconf-set-selections \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
        ca-certificates \
        winbind \
        dbus \
        procps \
        wget \
        sudo \
        locales \
        libfreetype6:i386 \
        lib32gcc-s1 \
        libgl1-mesa-glx \
        lib32stdc++6 \
        lib32z1 \
        steamcmd \
        xvfb \
        xserver-xorg \
        libvulkan1:i386 \
        wine

RUN ln -s /usr/games/steamcmd /usr/bin/steamcmd \
    && echo 'LANG="en_US.UTF-8"' > /etc/default/locale \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen \
    && rm -f /etc/machine-id \
    && dbus-uuidgen --ensure=/etc/machine-id \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && apt-get autoremove -y

COPY files/ /opt/config/default/
RUN chmod +x /opt/config/default/scripts/start-server.sh
RUN /bin/sh -c echo "* hard nice -20" | tee -a /etc/security/limits.conf

RUN adduser steam sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER steam
RUN mkdir "${SERVER_DIR}" \
    && mkdir "${STEAM_PATH}" \
    && mkdir "${STEAM_HOME}/.steam" \
    && steamcmd +quit \
    && ln -s "${STEAM_HOME}/.local/share/Steam/steamcmd/linux32" "${STEAM_HOME}/.steam/sdk32" \
    && ln -s "${STEAM_HOME}/.local/share/Steam/steamcmd/linux64" "${STEAM_HOME}/.steam/sdk64"\
    && ln -s "${STEAM_HOME}/.steam/sdk32/steamclient.so" "${STEAM_HOME}/.steam/sdk32/steamservice.so" \
    && ln -s "${STEAM_HOME}/.steam/sdk64/steamclient.so" "${STEAM_HOME}/.steam/sdk64/steamservice.so"

RUN chown -R steam:steam -R ${STEAM_HOME}
CMD ["/opt/config/default/scripts/start-server.sh"]
