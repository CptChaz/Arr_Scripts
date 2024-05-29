#!/bin/bash
#
# Author: [Cpt. Chaz]
# Created: [04/23/23]
# Updated: [05/13/24]
# Description: This is intended to be a startup script for Radarr v4+. Currently the script installs python3, pip, and the "requests" module. 
# Place script in the /custom-cont-init.d folder for execution at startup, and modify to fit individual need. This is exactly the same as the sonarr v4 startup script.
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.
#
# Update the package manager and install Python 3, pip, and other dependencies
apk update
apk add python3 py3-pip libxml2 libxslt-dev libffi-dev gcc musl-dev openssl-dev py3-requests

echo " "
echo "all done"
echo " "
