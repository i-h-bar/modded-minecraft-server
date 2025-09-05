#!/bin/bash

docker stop minecraft-server
echo "Stopped"

docker start minecraft-server
echo "Started"
