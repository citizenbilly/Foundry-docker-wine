# Foundry Dedicated Server - Docker Image
[![Steam Game](https://img.shields.io/badge/Steam-Foundry-8A2BE2)](https://store.steampowered.com/app/983870/FOUNDRY/)
[![Github-Foundry](https://img.shields.io/badge/GitHub-Foundry-green)](https://github.com/citizenbilly/Foundry-docker-wine)

# Foundry Dedicated Server - Docker Image
[![Steam Game](https://img.shields.io/badge/Steam-Foundry-8A2BE2)](https://store.steampowered.com/app/983870/FOUNDRY/)
[![Github-Foundry](https://img.shields.io/badge/GitHub-Foundry-green)](https://github.com/citizenbilly/Foundry-docker-wine)
[![Image Size](https://img.shields.io/docker/image-size/citizenbilly/foundry-wine)](https://hub.docker.com/r/citizenbilly/foundry-wine/tags)


## Overview:

This is an ongoing build as my first docker image. 
Base image Debian-bookworm slim and App running with SteamCMD and Wine.

- Server Data Directory: /home/steam/foundry
- Default Ports:
    - 27015/UDP
    - 3724/UDP

## Server Customizations
The default app.cfg will be provided during the server's initial run. 
The following Environment edited to customize the server configuration.

| Variable           | Default Value|
|----------------|---------------|
SERVER_NAME   |  FoundryServer |
WORLD_NAME    |  FoundryWine |
SERVER_PASSWORD  |  docker |
GAME_PORT  |   3724 |
QUERY_PORT  |   3724 |
SERVER_IS_PUBLIC    | false |
SERVER_SLOTS  |   16 |


## Docker Compose
```
version: "3"
services:
  app:
    container_name: foundry-dedicated
    image: citizenbilly/foundry-wine:latest
    restart: unless-stopped
    environment:
      - "SERVER_NAME=Foundry"
      - "WORLD_NAME=Foundry"
      - "SERVER_PASSWORD=Youshallnotpass"
      - "GAME_PORT=3724"
      - "QUERY_PORT=27015"
      - "SERVER_IS_PUBLIC=false"
      - "SERVER_SLOTS=8"
    ports:
      - "3724:3724"
      - "27015:27015"
```

| Task           | Status  | Notes |
|----------------|----------|-----|
| Deployed w/ docker-compose   | Complete |
| Deployed w/ Unraid   | Complete |
| Scheduled Backups   | WIP | |
| Addtional Variables   | WIP | Steam User/Pass, MappSeed|
| Repalce wine w/proton   |  N/A | N/A