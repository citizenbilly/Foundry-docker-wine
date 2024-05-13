# Foundry Dedicated Server - Docker Image
[![Image Size](https://img.shields.io/docker/image-size/citizenbilly/foundry-wine?logo=docker)](https://hub.docker.com/r/citizenbilly/foundry-wine/tags)
[![Image Pulls](https://img.shields.io/docker/pulls/citizenbilly/foundry-wine?logo=docker)](https://hub.docker.com/r/citizenbilly/foundry-wine/tags)<br />
[![Github"](https://img.shields.io/badge/GitHub-Foundry%20Docker%20Wine-green?logo=github)](https://github.com/citizenbilly/Foundry-docker-wine)<br />

[![Steam Game](https://img.shields.io/badge/Steam-Foundry-8A2BE2?logo=steam)](https://store.steampowered.com/app/983870/FOUNDRY/)<br />

## Overview:
This image will provide a running Foundry dedicated server.

Debian:Bookworm-slim<br />

## Server Customizations
The default app.cfg will be provided during the server's initial run.<br/>
Environment variables may be edited to customize the server configuration.

| Variable Name        | Description           | Default Value|
|----------------|---------------|---------------|
SERVER_NAME   |  Name of the server listed in the Steam server browser. | FoundryServer |
WORLD_NAME    |  Server World Name. Used for folder name where save files are stored. |FoundryWine |
SERVER_PASSWORD  |  Sets the server password. | docker |
GAME_PORT  |   Network port used by the game. | 3724 |
QUERY_PORT  | Network port used by the Steam server browser (if Public). | 27015 |
SERVER_IS_PUBLIC | Sets whether the server is listed on the Steam server browser.   | false |
SERVER_SLOTS  |  Max number of players on the server.  | 16 |
PAUSE_WHEN_EMPTY |  The server will pause when no player is connected.| false|
MAPP_SEED | Sets the map seed used to generate the world. | 42938743982 |


## Docker Compose
Following is an example of docker-compose file that would allow you to run the container. <br />
Important Note: Ensure that you specify UDP as the protocol for port(s). Docker will default to TCP.
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
      - "3724:3724/udp"
      - "27015:27015/udp"
```

