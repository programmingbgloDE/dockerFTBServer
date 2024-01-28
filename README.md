# Docker container for FTB Server
Table of Contents
- [Docker container for FTB Server](#docker-container-for-ftb-server)
  - [Prerequisites](#prerequisites)
  - [Setup](#setup)
  - [Run Container](#run-container)
    - [Environment Variables](#environment-variables)
    - [Pack id and version id](#pack-id-and-version-id)
      - [Example](#example)
  - [Docker compose file](#docker-compose-file)
  - [Troubleshooting](#troubleshooting)
    - [No `docker compose`](#no-docker-compose)
    - [`Bind for 0.0.0.0:25565 failed`](#bind-for-000025565-failed)


## Prerequisites

+ you need to have docker and docker compose installed


## Setup

+ To use this, get the Dockerfile and start script with `git clone`.

+ To build the container run

    ```
    docker build --build-args:"JAVA_VERSION=8" -t ftb_server:latest .
    ```

    in the downloaded Directory

+ now you can run a container


## Run Container

### Environment Variables

The server is controlled by environment variables. The variables are as follows.

+ `$PACKID` from FTB site
+ `$VERID` from FTB site
+ `$MAXRAM` max amount of RAM usable to the server
+ `$JARFILE` the jarfile to run the server, can be different for different mod packs
+ `$THREADS` The number of threads available for unpacking the mod pack

### Pack id and version id
You can get those numbers from the official [FTB site](https://www.feed-the-beast.com/modpacks). If you click on one modepack you will find the server files at the top. If you hover over the download links, you will see the id and version in the link.

#### Example
As an example we will use FTB Ultimate anniversary edition.

The link for the download is

```
https://api.modpacks.ch/public/modpack/93/2114/server/linux
```

for the linux version.
In this link, the first number, here 93, is the pack id and the second number (2114) is the version id. So to use the container with this pack you would insert those numbers into the two environment variables.


## Docker compose file

The best way of using this would be a docker compose file. 
An example would be:
```YAML 
version: "3.9"
services:
  server:
    image: ftb_server:latest
    ports:
      - "25565:25565"
    environment:
      - PACKID=93
      - VERID=2114
      - THREADS=4
      - MAXRAM=10240M
    volumes:
      - ./server:/modserver 
```
For this to work properly, you need to create a folder named `server` in the same directory as your `docker-compose.yml`.
After creating this file, you can run it with
```
docker compose up
```
and you will see the container start and loading all the nessecary files and stopping.

After this you need to add one last line to the docker-compose file.
```YAML
version: "3.9"
services:
  server:
    image: ftb_server:latest
    ports:
      - "25565:25565"
    environment:
      - PACKID=93
      - VERID=2114
      - THREADS=4
      - MAXRAM=10240M
      - JARFILE=forge-1.16.5-36.2.26.jar
    volumes:
      - ./server:/modserver 
```
You can find the file name in your server Directory.
Carefull there might be two .jar files however only one will work correctly, this is in this case the forge-***.jar File. You might need to test, which one works for you.

After this you can run the container with
```
docker compose up
```
to see the log output on your screen, or
```
docker compose start
```
to start the container in the background and be able to log out of your server without the container stopping.


## Troubleshooting

### No `docker compose`
 If you get the following error
 ```
 docker: 'compose' is not a docker command.
See 'docker --help'
 ```
you are running an older version of docker compose.
You just need to replace
```
docker compose
```
with
```
docker-compose
```

### `Bind for 0.0.0.0:25565 failed`
If you encounter the following error
```
Creating ftb-server_server_1 ... 
Creating ftb-server_server_1 ... error

ERROR: for ftb-server_server_1  Cannot start service server: driver failed programming external connectivity on endpoint ftb-server_server_1 (97f0db088c187a8d51149b9db44483bba7c6784e7442b6dc64d2eb9431a5005c): Bind for 0.0.0.0:25565 failed: port is already allocated

ERROR: for server  Cannot start service server: driver failed programming external connectivity on endpoint ftb-server_server_1 (97f0db088c187a8d51149b9db44483bba7c6784e7442b6dc64d2eb9431a5005c): Bind for 0.0.0.0:25565 failed: port is already allocated
ERROR: Encountered errors while bringing up the project.
```

This means that there is already a service runnig on port 25565, which is the standard port for Minecraft. If this is the case, you need to change the exposed port in your `docker-compose.yml`.

From
```
      - "25565:25565"
```
to
```
      - "25566:25565"
```
for example. This will expose your server on the new port. But don't forget to add the port to your address for your minecraft server.
