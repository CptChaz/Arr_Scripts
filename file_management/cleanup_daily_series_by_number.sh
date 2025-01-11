#!/usr/bin/env bash

# Author: [Cpt. Chaz]
# Created: [02/04/23]
# Revised: [01/10/25]
# Description: This script deletes and keeps only a certain number of user-set episodes (files), for multiple tv show directories. This script permanently removes files from the filesystem, so use with caution.
# Usage: Set the root directory, number of files to keep, and show names in the “User Configuration” section, then manually run the script, or set up a cron schedule.
# 	How It Works:
# 		1. Loops through each show’s directory.
# 		2. Sorts all files by modification date (newest first).
# 		3. Removes everything past the specified number to keep.
# 		4. Logs all deletions for easy review.
# Status: Tested
#
# Credits:
# - This script was modified with the help of ChatGPT o1, an OpenAI language model.


###############################################################################
#                            USER CONFIGURATION
###############################################################################
ROOT_DIR="/mnt/user/media/Plex/TV Shows/Regular TV Shows"  # Example Root folder (can contain spaces) <- CHANGE THIS
FILES_TO_KEEP=15                                           # Number of most recent files to keep <- CHANGE THIS
SHOWS=(
    "The Daily Show"		#<-- Examples
    "Jeopardy!"
    "Last Week Tonight with John Oliver"
)
###############################################################################
#                  DO NOT MODIFY ANYTHING BELOW THIS LINE
###############################################################################

# Array to store deleted files
DELETED_FILES=()

delete_old_episodes() {
    local dir="$1"
    local files_to_keep="$2"

    echo "Checking directory: $dir"

    # Gather all files sorted by modification time (newest first)
    mapfile -t all_files < <(find "$dir" -type f -print0 2>/dev/null | xargs -0 ls -1t 2>/dev/null)

    local files_count=${#all_files[@]}
    local files_to_delete_count=$((files_count - files_to_keep))

    if [[ "$files_to_delete_count" -gt 0 ]]; then
        for (( i=files_to_keep; i<files_count; i++ )); do
            echo "Deleting: ${all_files[$i]}"
            rm -v "${all_files[$i]}"
            DELETED_FILES+=("${all_files[$i]}")
        done
    else
        echo "No files to delete. (Total: $files_count, Keep: $files_to_keep)"
    fi
}

main() {
    for show_name in "${SHOWS[@]}"; do
        # Build the full path for each show directory
        local show_dir="$ROOT_DIR/$show_name"

        # Run deletion logic
        delete_old_episodes "$show_dir" "$FILES_TO_KEEP"
    done

    # Print summary
    echo -e "\nSummary of Deleted Files:"
    if [[ ${#DELETED_FILES[@]} -eq 0 ]]; then
        echo "No files were deleted."
    else
        for file in "${DELETED_FILES[@]}"; do
            echo "$file"
        done
    fi
    echo "Cleanup complete."
}

main "$@"
