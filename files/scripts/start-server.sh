#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

echo "---Installing Foundry Dedicated Server---"
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${APPID} \
    +quit

    echo "---Copying Server Configuration File---"
if [ ! -f ${SERVER_DIR}/app.cfg ]; then
  echo "---Config file not present, copying default file---"
  cp /opt/config/default/app.cfg ${SERVER_DIR}/app.cfg
else
        echo "---'app.cfg' found---"
fi

server_persistent_data_override_folder=${SERVER_DIR}/foundry/persistentdata

echo "[INFO] --Updating Server Configuration app.cfg--"
if [ "${SERVER_NAME}" == "" ]; then echo "Server Name: FoundryServer"
else sed -i "s/FoundryServer/${SERVER_NAME}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${WORLD_NAME}" == "" ]; then echo "Server World Name: FoundryProton"
else sed -i "s/FoundryServer/${WORLD_NAME}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${SERVER_PASSWORD}" == "" ]; then echo "Server Password: docker"
else sed -i "s/FoundryServer/${SERVER_PASSWORD}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${GAME_PORT}" == "" ]; then echo "Server Game Port: 3724"
else sed -i "s/3724/${GAME_PORT}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${QUERY_PORT}" == "" ]; then echo "Server Query Port: 27015"
else sed -i "s/27015/${QUERY_PORT}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${SERVER_IS_PUBLIC}" == "" ]; then echo "Server Is Public: false"
else sed -i "s/false/${SERVER_IS_PUBLIC}/g" ${SERVER_DIR}/app.cfg
fi

if [ "${MAP_SEED}" == "" ]; then echo "Server Mapp Seed: 42938743982"
fi

if [ "${SERVER_SLOTS}" == "" ]; then echo "Server Slots: 16"
else sed -i "s/16/${SERVER_SLOTS}/g" ${SERVER_DIR}/app.cfg
fi

echo "---Starting Foundry Dedicated Server---"
cp /opt/config/default/steam_appid.txt /home/steam/foundry/steam_appid.txt

Xvfb :0 -screen 0 640x480x24:32 &
DISPLAY=:0.0 wine ${SERVER_DIR}/FoundryDedicatedServer.exe -log 2>&1 &

timeout=0
while [ $timeout -lt 11 ]; do
  if ps -e | grep "FoundryDedicate"; then
    foundry_pid=$(ps -e | grep "FoundryDedicate" | awk '{print $1}')
  fi
    sleep 8
    ((timeout++))
    echo "$(timestamp) INFO: Waiting for Foundry Dedicated Server to start"
done
      echo ""
      echo ""
      echo "Server Name: ${SERVER_NAME}"
      echo "Server World Name: ${WORLD_NAME}"
      echo "Server Password: ${SERVER_PASSWORD}"
      echo "Server Query Port: ${QUERY_PORT}"
      echo "Server Game Port: ${GAME_PORT}"
      echo "Server Is Public: ${SERVER_IS_PUBLIC}"
      echo "Server Slots: ${SERVER_SLOTS}"

tail --pid=$foundry_pid -f /dev/null

echo "Error: The foundry server stopped"
exit 1
