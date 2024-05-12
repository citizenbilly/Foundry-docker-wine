# Foundry Dedicated Server - Docker Image

[![Image Size](https://img.shields.io/docker/image-size/citizenbilly/foundry-wine)](https://hub.docker.com/r/citizenbilly/foundry-wine/tags)


Steam Link: [Foundry Dedicated Server](https://store.steampowered.com/app/983870/FOUNDRY/). 

## Overview:

This is an ongoing build as my first docker image. Base image Debian-bookworm slim and App runs with SteamCMD and Wine.

| Task           | Status  | Notes |
|----------------|----------|-----|
| Deploy with Unraid   | Testing | Local Testing Successful|
| Scheduled Backups   | WIP | N/A|
| Repalce wine w/proton   |  WIP | [Foundry-docker-proton](https://github.com/citizenbilly/Foundry-docker-proton)

## Server Customizations
The default app.cfg will be provided during the server's initial run. The following variables may be modified to customize the server configuration.

## Environment variables
| Variable           | Default Value|
|----------------|---------------|
SERVER_NAME   |  FoundryServer |
WORLD_NAME    |  FoundryProton |
SERVER_PASSWORD  |  docker |
GAME_PORT  |   3724 |
QUERY_PORT  |   3724 |
SERVER_IS_PUBLIC    | 27015 |
SERVER_SLOTS  |   16 |
