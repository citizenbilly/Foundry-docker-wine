#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

echo "[INFO] Installing Foundry Dedicated Server"
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${APPID} \
    +quit

echo "[INFO] Validating Server Configuration File"
if [ ! -f ${SERVER_DIR}/app.cfg ]; then
  cp /opt/config/default/app.cfg ${SERVER_DIR}/app.cfg
else
  echo "[OK] Server Configuration Found"
fi

echo "[INFO] Updating Server Configuration File"
APP_CFG="${SERVER_DIR}/app.cfg"
  sed -i "s/server_name=FoundryServer/server_name=${SERVER_NAME}/g" ${APP_CFG}
  sed -i "s/server_world_name=FoundryProton/server_world_name=${WORLD_NAME}/g" ${APP_CFG}
  sed -i "s/server_password=docker/server_password=${SERVER_PASSWORD}/g" ${APP_CFG}
  sed -i "s/server_port=3724/server_port=${GAME_PORT}/g" ${APP_CFG}
  sed -i "s/server_query_port=27015/server_query_port=${QUERY_PORT}/g" ${APP_CFG}
  sed -i "s/server_is_public=false/server_is_public=${SERVER_IS_PUBLIC}/g" ${APP_CFG}
  sed -i "s/pause_server_when_empty=false/pause_server_when_empty=${PAUSE_WHEN_EMPTY}/" ${APP_CFG}
  sed -i "s/server_max_players=16/server_max_players=${SERVER_SLOTS}/g" ${APP_CFG}
  sed -i "s/autosave_interval=300/autosave_interval=${AUTOSAVE_INT}/g" ${APP_CFG}
  sed -i "s/mapseed=42938743982/mapseed=${MAP_SEED}/g" ${APP_CFG}

echo "[INFO] Starting Foundry Dedicated Server"
  cp /opt/config/default/steam_appid.txt /home/steam/foundry/steam_appid.txt
  Xvfb :0 -screen 0 640x480x24:32 &
  DISPLAY=:0.0 wine ${SERVER_DIR}/FoundryDedicatedServer.exe -log 2>&1 &

foundry_pid=$(ps -e | grep "FoundryDedicate" | awk '{print $1}')
timeout=0
while [ $timeout -lt 11 ]; do
  if ps -e | grep "FoundryDedicate"; then
    foundry_pid=$(ps -e | grep "FoundryDedicate" | awk '{print $1}')
  fi
  sleep 8
  ((timeout++))
done

if [ -z $foundry_pid ]; then
  echo "[ERROR] Foundry Dedicated Server failed to start."
else
  echo ""
  echo -e "-----Server Details-----\n"
  echo "Server Name: ${SERVER_NAME}"
  echo "World Name: ${WORLD_NAME}"
  echo "Password: ${SERVER_PASSWORD}"
  echo "Query Port: ${QUERY_PORT}"
  echo "Game Port: ${GAME_PORT}"
  echo "Is Public: ${SERVER_IS_PUBLIC}"
  echo "Server Slots: ${SERVER_SLOTS}"
  echo -e "\n-------------------------"
        
  tail --pid=$foundry_pid -f /dev/null
fi

echo "[ERROR] The foundry server stopped"