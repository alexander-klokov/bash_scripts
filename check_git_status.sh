#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check if changes are pushed to the remote origin
check_remote_push() {
    local_branch=$(git rev-parse --abbrev-ref HEAD)
    git fetch -q origin "$local_branch"
    local_commits=$(git rev-list HEAD ^origin/"$local_branch")

    if [ -z "$local_commits" ]; then
        return 0  # All changes are pushed
    else
        return 1  # Unpushed changes exist
    fi
}

# Iterate through directories
for dir in */; do
    # Check if the directory is a Git repository
    if [ -d "$dir/.git" ]; then
        # Change into the directory
        cd "$dir"

        # Check if there are uncommitted changes
        if [ -n "$(git status -s)" ]; then
            echo -e "${RED}Uncommitted changes in $dir${NC}"
        else
            # Check if changes are pushed to the remote origin
            if check_remote_push; then
                echo -e "${GREEN}All changes pushed in $dir${NC}"
            else
                echo -e "${RED}Unpushed changes in $dir${NC}"
            fi
        fi

        # Move back to the original directory
        cd ..
    else
        echo "$dir is not a Git repository"
    fi
done