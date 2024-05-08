#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

echo "[INFO] --Fetching GE-Proton${GE_PROTON_VERSION}---"
wget "${GE_PROTON_URL}" -O "${HOME}/GE-Proton${GE_PROTON_VERSION}.tgz" \
&& tar -x -C "${STEAM_PATH}/compatibilitytools.d/" -f "${HOME}/GE-Proton${GE_PROTON_VERSION}.tgz"
rm ${HOME}/GE-Proton${GE_PROTON_VERSION}.tgz

echo "[INFO] ---Checking for SteamCMD Updates---"
if [ "${STEAM_USERNAME}" == "" ]; then
  steamcmd \
  +login anonymous \
  +quit
else
  steamcmd \
  +login ${STEAM_USERNAME} ${STEAM_PASSWRD} \
  +quit
fi

echo "[INFO] ---Validating installation---"
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${APPID} validate \
    +quit

    echo "---Copy Config---"

if [ ! -f ${SERVER_DIR}/app.cfg ]; then
  echo "---Config file not present, copying default file---"
  cp /opt/config/default/app.cfg ${SERVER_DIR}/app.cfg
else
        echo "---'app.cfg' found---"
fi

server_persistent_data_override_folder=${SERVER_DIR}/foundry/persistentdata

echo "[INFO] --Updating Server Configuration--"
if [ "${SERVER_NAME}" == "" ]; then echo "Server Name: FoundryServer"
else sed -i "s/FoundryServer/${SERVER_NAME}/" ${SERVER_DIR}/app.cfg
fi

if [ "${WORLD_NAME}" == "" ]; then echo "Server World Name: FoundryProton"
else sed -i "s/FoundryServer/${WORLD_NAME}/" ${SERVER_DIR}/app.cfg
fi

if [ "${SERVER_PASSWORD}" == "" ]; then echo "Server Password: docker"
else sed -i "s/FoundryServer/${SERVER_PASSWORD}/" ${SERVER_DIR}/app.cfg
fi

if [ "${GAME_PORT}" == "" ]; then echo "Server Game Port: 3724"
else sed -i "s/3724/${SERVER_NAME}/" ${SERVER_DIR}/app.cfg
fi

if [ "${QUERY_PORT}" == "" ]; then echo "Server Query Port: 27015"
else sed -i "s/27015/${QUERY_PORT}/" ${SERVER_DIR}/app.cfg
fi

if [ "${SERVER_IS_PUBLIC}" == "" ]; then echo "Server Is Public: false"
else sed -i "s/false/${SERVER_IS_PUBLIC}/" ${SERVER_DIR}/app.cfg
fi

if [ "${MAP_SEED}" == "" ]; then echo "Server Mapp Seed: 42938743982"
else sed -i "s/42938743982/${MAP_SEED}/" ${SERVER_DIR}/app.cfg
fi

if [ "${SERVER_SLOTS}" == "" ]; then echo "Server Slots: 16"
else sed -i "s/16/${SERVER_SLOTS}/" ${SERVER_DIR}/app.cfg
fi

echo -t "[INFO] ---Setting Steam AppID---"
echo 983870 >${SERVER_DIR}/steam_appid.txt
SteamAppId=983870
SteamGameId=983870

WINEARCH=win32

Xvfb :0 -screen 0 640x480x24:32 -ac -nolisten tcp -nolisten unix &
echo -t "[INFO] ---Starting Foundry Dedicated Server---"
DISPLAY=:0.0 ${ASTEAM_PATH}/GE-Proton${GE_PROTON_VERSION}/wine64 ${SERVER_DIR}/FoundryDedicatedServer.exe -log 2>&1