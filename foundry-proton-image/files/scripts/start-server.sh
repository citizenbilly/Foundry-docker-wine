#!/bin/bash

timestamp () {
  date +"%Y-%m-%d %H:%M:%S,%3N"
}

if [ ! -f ${STEAMCMD_DIR}/steamcmd.sh ]; then
  echo "SteamCMD not found!"
  wget -q -O ${STEAMCMD_DIR}/steamcmd_linux.tar.gz http://media.steampowered.com/client/steamcmd_linux.tar.gz 
  tar --directory ${STEAMCMD_DIR} -xvzf /serverdata/steamcmd/steamcmd_linux.tar.gz
  rm ${STEAMCMD_DIR}/steamcmd_linux.tar.gz
fi

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

echo "---Updating ${GAME_NAME} Dedicated Server---"
if [ "${USERNAME}" == "" ]; then
  if [ "${VALIDATE}" == "true" ]; then
    echo "---Validating installation---"
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${APPID} validate \
    +quit
  else
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login anonymous \
    +app_update ${APPID} \
    +quit
  fi
else
  if [ "${VALIDATE}" == "true" ]; then
    echo "---Validating installation---"
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${APPID} validate \
    +quit
  else
    steamcmd \
    +@sSteamCmdForcePlatformType windows \
    +force_install_dir ${SERVER_DIR} \
    +login ${USERNAME} ${PASSWRD} \
    +app_update ${APPID} \
    +quit
  fi
fi

echo "---Prepare Server---"
chmod -R ${DATA_PERM} ${DATA_DIR}

if [ ! -f ${SERVER_DIR}/app.cfg ]; then
  echo "---Config file not present, copying default file---"
  cp /opt/config/default/app.cfg ${SERVER_DIR}/app.cfg
else
        echo "---'app.cfg' found---"
fi

# Wine talks too much and it's annoying
#export WINEDEBUG=-all

echo "---Server ready---"

echo "---Start Server---"

if [ "${BACKUP}" == "true" ]; then
  echo "---Starting Backup daemon---"
  echo "Interval: ${BACKUP_INTERVAL} minutes and keep ${BACKUPS_TO_KEEP} backups"
  if [ ! -d ${SERVER_DIR}/Backups ]; then
    mkdir -p ${SERVER_DIR}/Backups
  fi
  /opt/scripts/start-backup.sh &
fi

if [ ! -f ${SERVER_DIR}/FoundryDedicatedServer.exe ]; then
  echo "---Something went wrong, can't find the executable, putting container into sleep mode!---"
  sleep infinity
else
  ${ASTEAM_PATH}/GE-Proton${GE_PROTON_VERSION}/proton run ${SERVER_DIR}/FoundryDedicatedServer.bat ${GAME_PARAMS} &
  
  # Find pid for FoundryDedicatedServer.exe
  timeout=0
  while [ $timeout -lt 11 ]; do
    if ps -e | grep "FoundryDedicate"; then
      foundry_pid=$(ps -e | grep "FoundryDedicate" | awk '{print $1}')

      if [ "${BACKUP}" == "true" ]; then
        echo "---Starting Backup daemon---"
        echo "Interval: ${BACKUP_INTERVAL} minutes and keep ${BACKUPS_TO_KEEP} backups"
        if [ ! -d ${SERVER_DIR}/Backups ]; then
          mkdir -p ${SERVER_DIR}/Backups
        fi
        /opt/scripts/start-backup.sh &
      fi
      tail -n 9999 -f ${SERVER_DIR}/logs/foundry_server.log
      break
    elif [ $timeout -eq 10 ]; then
        echo "$(timestamp) ERROR: Timed out waiting for FoundryDedicatedServer.exe to be running"
      sleep infinity
    fi
    sleep 6
    ((timeout++))
    echo "$(timestamp) INFO: Waiting for FoundryDedicatedServer.exe to be running"
  done

  # I don't love this but I can't use `wait` because it's not a child of our shell
  tail --pid=$foundry_pid -f /dev/null

  # If we lose our pid, exit container
  echo "$(timestamp) ERROR: Factory has imploded..."
  exit 1
fi
