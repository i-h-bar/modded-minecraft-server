# Minecraft Server Forge with Docker and ngrok

A lightweight setup to run a modded Minecraft Forge server inside Docker and expose it publicly via an ngrok TCP tunnel. Includes helper scripts to build/run, stop, restart, remove, and view logs.

## Prerequisites
- Docker installed
- Docker Compose V2 (the `docker compose` command)
- An ngrok account and an `NGROK_AUTHTOKEN` (https://ngrok.com/)



## Features
- Forge server, built automatically during the image build (Version specified by the FORGE_VERSION env var e.g FORGE_VERSION=1.19.2-43.3.5) .
- Java 21 runtime inside the container.
- EULA auto-accepted in the image (eula.txt set to true).
- Automatically exposes the server on port 25565.
- ngrok TCP tunnel for easy remote access (no port forwarding required).

## Repository layout
- Dockerfile — builds the Forge server image and sets defaults.
- docker-compose.yml — defines `minecraft-server` and `ngrok` services.
- run.sh — builds and starts the stack; prints the ngrok TCP URL.
- stop.sh — stops the Minecraft server container.
- restart.sh — restarts the Minecraft server container.
- remove.sh — stops and removes the whole stack (both services).
- logs.sh — follows the Minecraft server container logs.
- console.sh — opens the minecraft server console

## Quick start
1. Place your mods into a directory making note of the absolute path
2. make a `.env` file with the following structure:

```dotenv
MODS_DIR={{absolute path to the mods directory on your machine}}
NGROK_AUTHTOKEN={{Your NGROK token}}
MEMORY_ALLOCATION=8G  # Update as you need
FORGE_VERSION=1.19.2-43.3.5  # Update as you need
MINECRAFT_HOST_DIR={{abosolute path to a world file where the state of the world is saved}}
```

3. Run the `run.sh` shell script this will spin up 2 docker containers one for the server and one for the ngrok tunnel

4. After startup, `run.sh` will print lines from the ngrok container logs. Look for a line with the public TCP URL, e.g.:
   ```
   url=0.tcp.ngrok.io:12345
   ```
   Share that host and port with your friends to connect to your server.



## Configuration details
- Java: openjdk-21-jdk inside the image.
- EULA: `eula=true` is written during build; by using this project you acknowledge the Minecraft EULA.
- Memory: `user_jvm_args.txt` is set to `-Xmx8G` in the image. To change memory:
  - Option A: Edit the Dockerfile line that writes `user_jvm_args.txt`, then rebuild.
  - Option B: Bind-mount your own `user_jvm_args.txt` via docker-compose override (advanced).
- World persistence:
  - World is persisted in the `MINECRAFT_HOST_DIR` directory

## How it works
- `docker-compose.yml` defines:
  - `minecraft-server`: builds from the Dockerfile and runs Forge.
  - `ngrok`: starts a TCP tunnel targeting `minecraft-server:25565` and uses your `NGROK_AUTHTOKEN`.
- `run.sh` builds the images, brings up the services, waits briefly, and prints the ngrok URL from container logs.

## Requirements and acknowledgements
- You must comply with the Minecraft EULA and mod licenses.
- This project uses:
  - Minecraft Forge 1.20.1 (47.3.0)
  - openjdk-21-jdk
  - ngrok/ngrok container for tunneling
