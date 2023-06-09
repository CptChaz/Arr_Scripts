#!/bin/bash
#
# Author: [Cpt. Chaz]
# Created: [04/23/23]
# Description: This is intended to be a startup script for Sonarr v4+. Currently the script installs python3, pip, and the "requests" module. 
# Place script in the /custom-cont-init.d folder for execution at startup, and modify to fit individual need
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.
#
# Update the package manager and install Python 3, pip, and other dependencies
apk update
apk add python3 py3-pip libxml2 libxslt-dev libffi-dev gcc musl-dev openssl-dev

# Install the "requests" module
pip3 install requests

echo " "
echo "all done"
echo " "


