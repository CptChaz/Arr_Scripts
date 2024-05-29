#!/bin/bash
#
# Author: [Cpt. Chaz]
# Created: [05/27/24]
# Updated: 
# Description: This is intended to be a startup script for Sabnzbd in Linuxserver.io docker containers. Currently the script installs ffmpeg only. 
# Place script in the /custom-cont-init.d folder for execution at startup, and modify to fit individual need if necessary.
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT 4o, an OpenAI language model.
#
# Update the package manager and install ffmpeg
apk update
# Install or upgrade ffmpeg to the latest version
apk add --no-cache ffmpeg

echo " "
echo "all done"
echo " "
