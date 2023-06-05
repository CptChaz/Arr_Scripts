#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#
# Author: [Cpt. Chaz]
# Created: [04/24/23]
# Description: This script has been created with the intention of unmonitoring a specific episode that is downloaded and successfully imported in sonarr, but only ones 
# that meet a certain minimum video resolution requirement. 
# Expected behavior example: If resolution minimum is set to 1080p, and sonarr imports a 720p episode file, it will NOT be unmonitored. If sonarr imports a
# 1080p file, it WILL be unmonitored. Video resolution can be set to any preference. Be sure to set the variables
# in the script to your specific sonarr instance (ip, port, api, and resolution).
# This is the Python3 version v0.1
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.
# - This script is a build on to Casvt's original unmonitor_downloaded_episodes.py script https://github.com/Casvt/Plex-scripts/blob/main/sonarr/unmonitor_downloaded_episodes.py

"""
SETUP:
    Go to the Sonarr web-ui -> Settings -> Connect -> + -> Custom Script
        Name = whatever you want
        Triggers = 'On Import' and 'On Upgrade'
        Tags = whatever if needed
        path = /path/to/unmonitor_resolution_cutoff.py
"""

sonarr_ip = '192.168.1.1'
sonarr_port = '8989/sonarr'
sonarr_api_token = 'yourapihere'
video_resolution_cutoff = '1080p' #<-- change to your preference (note: required)

import requests
from os import environ

if environ.get('sonarr_eventtype') == 'Test':
    if sonarr_ip and sonarr_port and sonarr_api_token:
        exit(0)
    else:
        print('Error: Not all variables are set')
        exit(1)

episode_ids = str(environ.get('sonarr_episodefile_episodeids'))
episode_info_response = requests.get(
    'http://' + sonarr_ip + ':' + sonarr_port + '/api/v3/episode?apikey=' + sonarr_api_token + '&id=' + episode_ids
)
if episode_info_response.status_code == 200:
    episode_info = episode_info_response.json()
    for episode in episode_info:
        if 'quality' in episode and episode['quality']['quality']['resolution'] >= video_resolution_cutoff:
            requests.put(
                'http://' + sonarr_ip + ':' + sonarr_port + '/api/v3/episode/monitor?apikey=' + sonarr_api_token,
                json={'episodeids': [episode['id']], 'monitored': False}
            )
else:
    print('Error: Failed to retrieve episode information')
