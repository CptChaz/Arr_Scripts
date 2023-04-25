#!/usr/bin/env python3
#
# Author: [Cpt. Chaz]
# Created: [04/24/23]
# Description: This script has been created with the intention of unmonitoring ALL existing episode files on disk in your tv show library. 
# Expected behavior is for missing files/ episodes to remain unchanged in their original monitoring state (monitored or unmonitored). Be sure to set the variables
# in the script to your specific sonarr instance (ip, port, and api).
# This is the Python3 version v0.1
# Status: Untested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.

import requests

# Set Sonarr API parameters
sonarr_url = 'http://YOUR.IP.HERE:8989/api'
sonarr_api_key = 'YOURAPIKEYHERE'

# Get series list from Sonarr
series_list_response = requests.get(f'{sonarr_url}/series', headers={'X-Api-Key': sonarr_api_key})
series_list_response.raise_for_status()
series_list = series_list_response.json()

# Loop through each series
for series in series_list:
    series_id = series['id']
    series_path = series['path']

    # Mark all episodes as unmonitored
    unmonitor_payload = {
        'name': 'unmonitor',
        'seriesId': series_id,
        'seasonNumber': -1,
        'episodeNumber': -1
    }
    unmonitor_response = requests.put(f'{sonarr_url}/episode', headers={'X-Api-Key': sonarr_api_key}, json=unmonitor_payload)
    unmonitor_response.raise_for_status()

    # Scan series for missing episodes
    rescan_payload = {
        'name': 'RescanSeries',
        'seriesId': series_id
    }
    rescan_response = requests.post(f'{sonarr_url}/command', headers={'X-Api-Key': sonarr_api_key}, json=rescan_payload)
    rescan_response.raise_for_status()
