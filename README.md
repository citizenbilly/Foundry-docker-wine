# Foundry Dedicated Server - Docker Image
This is my first build of a docker image.
The end goal is to be able to run a Docker for [Foundry Dedicated Server](https://store.steampowered.com/app/983870/FOUNDRY/) with proton.

By default the image will deploy [Proton GE 9.4](https://github.com/GloriousEggroll/proton-ge-custom/releases/tag/GE-Proton9-4). This may also be changed by seting ```GE_PROTON_VERSION=``` to another version.


| Task           | Status  |
|----------------|---------------|
| Deploy with Unraid   | WIP |
| Repalce wine w/proton   |  WIP |


### Server Customizations
The default app.cfg will be provided during the server's initial run.
Changes may be made to the server configuration with the following variables.

## Environment variables
| Variable           | Default Value|
|----------------|---------------|
SERVER_NAME   |  FoundryServer |
WORLD_NAME    |  FoundryProton |
SERVER_PASSWORD  |  docker |
GAME_PORT  |   3724 |
QUERY_PORT  |   3724 |
SERVER_IS_PUBLIC    | 27015 |
MAP_SEED  |   in progress |
SERVER_SLOTS  |   in progress |
