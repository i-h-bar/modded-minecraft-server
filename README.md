# Minecraft Server: Forge with Docker and ngrok ⛏️

Spin up a **lightweight, modded Minecraft Forge server** in minutes! This setup uses Docker to containerize your server and a secure ngrok TCP tunnel to expose it publicly, so your friends can join without any complex port forwarding. This repo includes helper scripts to manage your server with ease.

---

## 🚀 Quick Start

Ready to get your server online? Follow these simple steps.

### 1. Prerequisites
Make sure you have these installed on your machine:

* **Docker:** The container runtime.
* **Docker Compose V2:** The `docker compose` command is used to orchestrate the services.
* **ngrok:** An ngrok account and a valid `NGROK_AUTHTOKEN` are needed to create the public tunnel.

### 2. Configure Your Server
1.  First, create a dedicated directory for your server's mods and a separate directory for the world's state and data.
2.  Next, create a `.env` file in the root of the project with the following structure, updating the values as needed:

```dotenv
MODS_DIR=/absolute/path/to/your/mods
MINECRAFT_HOST_DIR=/absolute/path/to/your/world/data
NGROK_AUTHTOKEN=your_ngrok_auth_token
MEMORY_ALLOCATION=8G  # Adjust the memory
FORGE_VERSION=1.19.2-43.3.5  # Set your desired Forge version
```
Note: The MINECRAFT_HOST_DIR is crucial for persisting your world data between sessions

### 3. Launch and Connect!
Run the run.sh script to get started. This script will build the necessary Docker images and launch two containers: one for the Minecraft server and one for the ngrok tunnel.

```Bash
./run.sh
```

After startup, the script will print the ngrok container logs. Look for a line that shows the public TCP URL:

```
url=0.tcp.ngrok.io:12345
```
Simply share this host and port with your friends, and they can connect directly to your server!


## ✨ Features
- Automatic Setup: The Forge server is built automatically during the image creation, so you don`t have to manually download anything.
- Mod Support: Easily add your favorite mods by placing them in the directory specified by `MODS_DIR`.
- Effortless Access: The ngrok TCP tunnel bypasses complex port forwarding and firewall configurations.
- Self-Contained Environment: The server runs in a container with a pre-configured Java 21 runtime.
- EULA Accepted: The Minecraft EULA is automatically accepted during the build process, so you can get straight to playing. By using this project, you agree to the terms of the Minecraft EULA.

## ⚙️ How It Works
This project uses a simple yet powerful combination of Docker and helper scripts.

- `docker-compose.yml`: This file defines the two main services: `minecraft-server` (which runs your modded game) and `ngrok` (which creates the secure tunnel). The `ngrok` service is configured to target the Minecraft container on port `25565`.
- `Dockerfile`: This script handles the server build process, including installing the specified Forge version and configuring Java settings.
- Helper Scripts: The `.sh` scripts provide a simple command-line interface to manage the server's lifecycle, from running and stopping to viewing logs and opening the console.

## 🛠️ Server Management Scripts
The repository includes a suite of helper scripts to make managing your server a breeze:

| Script | Description |
| --------- | -------- |
| run.sh | Builds and starts the entire stack. |
| stop.sh | Stops the Minecraft server container. |
| restart.sh | Restarts the Minecraft server container. |
| remove.sh | Stops and removes all containers and data. |
| logs.sh | Streams logs from the Minecraft container. |
| console.sh | Opens a live console for the server. |