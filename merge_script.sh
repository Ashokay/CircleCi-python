#!/bin/bash

# Read the manifest file and execute instructions
while IFS= read -r line; do
    action=$(echo "$line" | awk '{print $2}')

    if [ "$action" == "clone" ]; then
        repository=$(echo "$line" | awk '/repository/ {print $2}')
        path=$(echo "$line" | awk '/path/ {print $2}')
        git clone "$repository" "$path"
    elif [ "$action" == "merge" ]; then
        source=$(echo "$line" | awk '/source/ {print $2}')
        destination=$(echo "$line" | awk '/destination/ {print $2}')
        strategy=$(echo "$line" | awk '/strategy/ {print $2}')
        cd "$destination"
        git remote add source "$source"
        git pull source main --"$strategy"
    elif [ "$action" == "push" ]; then
        repository=$(echo "$line" | awk '/repository/ {print $2}')
        cd "$repository"
        git push origin main
    fi
done < merge_manifest.yaml
