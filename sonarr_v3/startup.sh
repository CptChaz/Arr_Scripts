#!/bin/bash

# Author: [Cpt. Chaz]
# Created: [04/23/23]
# Description: This is intended to be a startup script for Sonarr v3+ in Linuxserver.io docker containers. Currently the script installs python3, pip, and the "requests" module. 
# Place script in the /custom-cont-init.d folder for execution at startup, and modify to fit individual need (designed using lsio docker container)
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.
#
#Update and upgrade before installing any packages
echo "*** update & upgrade ***"
yes Y | apt-get update && apt-get upgrade

#Install Python3 & Pip
echo "*** installing python3 ***"
yes Y | apt-get install python3-pip

sleep 3

#Install Requests Module
echo "*** installing requests python package ***"
yes Y | python3 -m pip install requests

echo "all done!"
