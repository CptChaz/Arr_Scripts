#!/usr/bin/env python3
#
# Author: [Cpt. Chaz]
# Created: [05/27/24]
# Updated: 
# Description: This is intended to be a post processing script for sabnzbd. Script uses ffmpeg to check for any english audio streams in video files. (supports no metadata / (und) tagged streams) 
# REQUIREMENTS: ffmpeg
# Status: Tested
#
# Credits:
# - This script was created with the help of ChatGPT 4o, an OpenAI language model.
#

import os
import sys
import subprocess
import shutil

VIDEO_EXTENSIONS = {'.mp4', '.mkv', '.avi', '.mov', '.wmv', '.flv', '.m4v'}

def check_english_or_undetermined_audio(file_path):
    try:
        # Run ffmpeg to get the audio streams and their languages
        result = subprocess.run(
            ["ffmpeg", "-i", file_path],
            stderr=subprocess.PIPE,
            stdout=subprocess.PIPE
        )
        
        # Parse the output to check for English or undetermined audio streams
        output = result.stderr.decode('utf-8')
        for line in output.split('\n'):
            if 'Stream' in line and 'Audio' in line:
                if 'eng' in line or 'und' in line:
                    return True
        return False
    except Exception as e:
        print(f"Error checking audio streams: {e}")
        return False

def main():
    # Get the directory path from SABnzbd arguments
    dir_path = sys.argv[1]
    
    # Check if any video files in the directory have English or undetermined audio streams
    contains_valid_audio = False
    for root, _, files in os.walk(dir_path):
        for file in files:
            if os.path.splitext(file)[1].lower() in VIDEO_EXTENSIONS:
                file_path = os.path.join(root, file)
                if check_english_or_undetermined_audio(file_path):
                    contains_valid_audio = True
                    break
        if contains_valid_audio:
            break
    
    if contains_valid_audio:
        print("Directory contains video files with English or undetermined audio streams. No further action taken.")
        sys.exit(0)
    else:
        print("Directory does not contain any video files with English or undetermined audio streams. Deleting directory and marking download as failed.")
        try:
            shutil.rmtree(dir_path)
            print("Directory deleted successfully.")
        except Exception as e:
            print(f"Error deleting directory: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
