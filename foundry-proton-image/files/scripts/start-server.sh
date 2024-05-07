#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

echo "---Update SteamCMD---"
if [ "${USERNAME}" == "" ]; then
  steamcmd \
  +login anonymous \
  +quit
else
  steamcmd \
  +login ${USERNAME} ${PASSWRD} \
  +quit
fi

echo "---Validating installation---"
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

# Wine talks too much and it's annoying
#export WINEDEBUG=-all
SteamAppId=983870
SteamGameId=983870
echo "983870" > ${SERVER_DIR}/steam_appid.txt

Xvfb :0 -screen 0 640x480x24:32 &
DISPLAY=:0.0 ${ASTEAM_PATH}/GE-Proton${GE_PROTON_VERSION}/proton run ${SERVER_DIR}/FoundryDedicatedServer.exe -log 2>&1