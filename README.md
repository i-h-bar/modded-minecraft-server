# Minecraft Server (Forge 1.20.1) with Docker and ngrok

A lightweight setup to run a modded Minecraft Forge 1.20.1 server inside Docker and expose it publicly via an ngrok TCP tunnel. Includes helper scripts to build/run, stop, restart, remove, and view logs.

Current date: 2025-08-27

## Features
- Forge 1.20.1 (47.3.0) server, built automatically during the image build.
- Java 21 runtime inside the container.
- EULA auto-accepted in the image (eula.txt set to true).
- Default JVM memory: -Xmx8G (can be adjusted).
- Automatically exposes the server on port 25565.
- ngrok TCP tunnel for easy remote access (no port forwarding required).
- mods/ directory copied into the container at build-time for server-side mods.
- Optional host volume to persist the world data outside of the container.

## Repository layout
- Dockerfile — builds the Forge server image and sets defaults.
- docker-compose.yml — defines `minecraft-server` and `ngrok` services.
- run.sh — builds and starts the stack; prints the ngrok TCP URL.
- stop.sh — stops the Minecraft server container.
- restart.sh — restarts the Minecraft server container.
- remove.sh — stops and removes the whole stack (both services).
- logs.sh — follows the Minecraft server container logs.
- mods/ — place your server-side mod .jar files here before building.

## Prerequisites
- Docker installed
- Docker Compose V2 (the `docker compose` command)
- An ngrok account and an `NGROK_AUTHTOKEN` (https://ngrok.com/)

## Quick start
1. (Optional) Place your desired server-side mod `.jar` files into the `mods/` directory.
2. Run the project using your ngrok authtoken (and, optionally, a host directory for world persistence):

   - Without a host volume:
     ```bash
     ./run.sh <NGROK_AUTHTOKEN>
     ```
   - With a host volume to persist the world on your machine (recommended):
     ```bash
     ./run.sh <NGROK_AUTHTOKEN> /absolute/path/to/world-dir
     ```

   Notes:
   - The second argument, if provided, will be exported as `MINECRAFT_HOST_DIR` and mounted to `/minecraft/world/` inside the container. Use an absolute path.
   - The first run will build the image, which may take a few minutes.

3. After startup, `run.sh` will print lines from the ngrok container logs. Look for a line with the public TCP URL, e.g.:
   ```
   url=tcp://0.tcp.ngrok.io:12345
   ```
   Share that host and port with your friends to connect to your server.

## Scripts
- Start/Build and get ngrok URL:
  ```bash
  ./run.sh <NGROK_AUTHTOKEN> [MINECRAFT_HOST_DIR]
  ```
- Stop the Minecraft server container:
  ```bash
  ./stop.sh
  ```
- Restart the Minecraft server container:
  ```bash
  ./restart.sh
  ```
- Remove the whole stack (both `minecraft-server` and `ngrok`):
  ```bash
  ./remove.sh
  ```
- View Minecraft server logs:
  ```bash
  ./logs.sh
  ```

## Configuration details
- Forge version: 1.20.1 - 47.3.0 (installer fetched from Maven in Dockerfile).
- Java: openjdk-21-jdk inside the image.
- EULA: `eula=true` is written during build; by using this project you acknowledge the Minecraft EULA.
- Memory: `user_jvm_args.txt` is set to `-Xmx8G` in the image. To change memory:
  - Option A: Edit the Dockerfile line that writes `user_jvm_args.txt`, then rebuild.
  - Option B: Bind-mount your own `user_jvm_args.txt` via docker-compose override (advanced).
- World persistence:
  - If you pass a second argument to `run.sh`, it will be used as the `MINECRAFT_HOST_DIR` and mounted to `/minecraft/world/` in the container. This stores your world on the host.
  - If you omit it, the world remains inside the container filesystem (not persistent across rebuilds/removals).
- Ports: 25565 is exposed. The ngrok container creates a public TCP tunnel to this port.

## Mods
- Place compatible server-side Forge mods for 1.20.1 into the `mods/` directory before running `./run.sh`.
- The Dockerfile copies `mods/` into the image at build time to `/minecraft/mods/`.
- If you add or remove mods, rebuild the image:
  ```bash
  docker compose build
  docker compose up -d
  ```

## Troubleshooting
- ngrok URL not shown:
  - Run `docker logs ngrok-tunnel` and look for lines containing `url=tcp://...`.
  - Ensure your `NGROK_AUTHTOKEN` is valid and not rate-limited.
- Volume/permissions issues:
  - Make sure `MINECRAFT_HOST_DIR` is an absolute path and you have read/write permissions.
- Server doesn’t start or crashes:
  - Check `./logs.sh` for detailed errors (e.g., incompatible mods).
  - Try removing problematic mods or verifying version compatibility with Forge 1.20.1.
- Change memory allocation:
  - Update `user_jvm_args.txt` configuration as described above if you need more/less RAM.

## How it works
- `docker-compose.yml` defines:
  - `minecraft-server`: builds from the Dockerfile and runs Forge.
  - `ngrok`: starts a TCP tunnel targeting `minecraft-server:25565` and uses your `NGROK_AUTHTOKEN`.
- `run.sh` exports `NGROK_AUTHTOKEN` and optionally `MINECRAFT_HOST_DIR`, builds the images, brings up the services, waits briefly, and prints the ngrok URL from container logs.

## Requirements and acknowledgements
- You must comply with the Minecraft EULA and mod licenses.
- This project uses:
  - Minecraft Forge 1.20.1 (47.3.0)
  - openjdk-21-jdk
  - ngrok/ngrok container for tunneling
