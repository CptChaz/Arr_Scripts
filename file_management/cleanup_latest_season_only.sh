#!/bin/bash

# Author: [Cpt. Chaz]
# Created: [02/09/23]
# Revised: [01/10/25]
# Description: This script deletes and keeps only a certain number of user-set seasons (sub-directories), for multiple tv show directories. This script permanently removes files from the filesystem, so use with caution.
# Usage: Set the root directory, number of seasons to keep, and show names in the “User Configuration” section, then manually run the script, or set up a cron schedule. USUALLY RUN MONTHLY
# 	How It Works:
# 		1. For each show directory, the script gathers all subdirectories named “Season *”, sorts them, and removes all but the latest number of SEASONS_TO_KEEP.
#		  2. A summary of deleted season directories is printed at the end.
# 		
# Status: Tested
#
# Credits:
# - This script was modified with the help of ChatGPT o1, an OpenAI language model.

###############################################################################
#                            USER CONFIGURATION
###############################################################################
ROOT_DIR="/mnt/user/media/Plex/TV Shows/Regular TV Shows"  # Root folder (can have spaces) <- CHANGE THIS
SEASONS_TO_KEEP=1                                          # How many of the most recent seasons to keep
SHOWS=(
    "The Daily Show"	#<-- EXAMPLES
    "Jeopardy!"
    "Last Week Tonight with John Oliver"
)
###############################################################################
#                  DO NOT MODIFY ANYTHING BELOW THIS LINE
###############################################################################

DELETED_SEASONS=()

keep_latest_seasons() {
    local show_dir="$1"
    local keep_count="$2"

    echo "Checking show directory: $show_dir"

    # Find subdirectories matching "Season *" and sort them in ascending order
    mapfile -t season_dirs < <(find "$show_dir" -maxdepth 1 -mindepth 1 -type d -iname "Season *" -print0 2>/dev/null \
                               | xargs -0 ls -1d 2>/dev/null \
                               | sort --version-sort)

    local total_seasons=${#season_dirs[@]}
    local remove_count=$(( total_seasons - keep_count ))

    if [[ $remove_count -gt 0 ]]; then
        # Remove older season directories, keep the newest (last) ones
        for (( i=0; i<remove_count; i++ )); do
            echo "Removing older season directory: ${season_dirs[$i]}"
            rm -rf "${season_dirs[$i]}"
            DELETED_SEASONS+=("${season_dirs[$i]}")
        done
    else
        echo "No older seasons to remove. (Total seasons: $total_seasons, Keeping: $keep_count)"
    fi
}

main() {
    for show in "${SHOWS[@]}"; do
        local show_path="$ROOT_DIR/$show"

        if [[ -d "$show_path" ]]; then
            keep_latest_seasons "$show_path" "$SEASONS_TO_KEEP"
        else
            echo "Warning: Show directory not found: $show_path"
        fi
    done

    # Summary of deleted directories
    echo -e "\nSummary of Deleted Season Directories:"
    if [[ ${#DELETED_SEASONS[@]} -eq 0 ]]; then
        echo "No season directories were deleted."
    else
        for dir in "${DELETED_SEASONS[@]}"; do
            echo "$dir"
        done
    fi
    echo "Cleanup complete."
}

main "$@"
