#!/bin/bash

# Author: [Cpt. Chaz]
# Created: [04/24/23]
# Description: This script has been created with the intention of unmonitoring ALL existing episode files on disk in your tv show library. 
# Expected behavior is for missing files/ episodes to remain unchanged in their original monitoring state (monitored or unmonitored). Be sure to set the variables
# in the script to your specific sonarr instance (ip, port, and api).
# This is the BASH version v0.1
# Status: Untested
#
# Credits:
# - This script was created with the help of ChatGPT, an OpenAI language model.

# Set Sonarr API parameters
sonarr_ip="192.168.0.121"
sonarr_port="8989"
sonarr_api_key="cde816e8a5e44ac8affc9890e447003c"

# Get Sonarr series list
series_list=$(curl -s "http://${sonarr_ip}:${sonarr_port}/api/series?apikey=${sonarr_api_key}")

# Loop through each series
for series in $(echo "${series_list}" | jq -r '.[] | @base64'); do
    series_id=$(echo "${series}" | base64 --decode | jq -r '.id')
    series_path=$(echo "${series}" | base64 --decode | jq -r '.path')

    # Mark all episodes as unmonitored
    curl -s -X PUT "http://${sonarr_ip}:${sonarr_port}/api/episode/?apikey=${sonarr_api_key}" \
        -H "Content-Type: application/json" \
        -d '{"name": "unmonitor", "seriesId": "'${series_id}'", "seasonNumber": -1, "episodeNumber": -1}'

    # Scan series for missing episodes
    curl -s -X POST "http://${sonarr_ip}:${sonarr_port}/api/command/?apikey=${sonarr_api_key}" \
        -H "Content-Type: application/json" \
        -d '{"name": "RescanSeries", "seriesId": "'${series_id}'"}'
done
