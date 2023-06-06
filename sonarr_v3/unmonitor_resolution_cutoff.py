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
# - This script was modified with the help of ChatGPT, an OpenAI language model.
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
import re
from os import environ

if environ.get('sonarr_eventtype') == 'Test':
    if sonarr_ip and sonarr_port and sonarr_api_token and cutoff:
        exit(0)
    else:
        print('Error: Not all variables are set')
        exit(1)

sonarr_episodefile_episodeids = str(environ.get('sonarr_episodefile_episodeids'))

# New if statement to check video cutoff
if cutoff == '1080p':
    # Add code to check if the episode meets the cutoff criteria
    episode_quality_str = environ.get('sonarr_episodefile_quality')
    episode_quality_match = re.search(r'(\d+)', episode_quality_str)
    if episode_quality_match:
        episode_quality = int(episode_quality_match.group(1))
        cutoff_quality = int(cutoff[:-1])  # Convert cutoff to numeric format
        if episode_quality < cutoff_quality:
            print('Episode not unmonitored. Quality does not meet the cutoff.')
            exit(0)
        else:
            # Continue with the rest of the script
            sonarr_episodefile_episodeids = str(environ.get('sonarr_episodefile_episodeids'))
            requests.put('http://' + sonarr_ip + ':' + sonarr_port + '/api/v3/episode/monitor?apikey=' + sonarr_api_token, json={'episodeids': [sonarr_episodefile_episodeids], 'monitored': False})
    else:
        print('Error: Failed to extract numeric quality from', episode_quality_str)
        exit(1)
