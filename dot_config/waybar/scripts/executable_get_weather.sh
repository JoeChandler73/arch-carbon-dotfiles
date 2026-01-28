#!/usr/bin/env bash

# Use Bash range syntax {1..5} and ensure 'do' is present
for i in {1..5}
do
    text=$(curl -s "https://wttr.in/$1?format=1")
    if [[ $? == 0 ]]
    then
        # Clean up whitespaces
        text=$(echo "$text" | sed -E "s/\s+/ /g")
        tooltip=$(curl -s "https://wttr.in/$1?format=4")
        
        if [[ $? == 0 ]]
        then
            tooltip=$(echo "$tooltip" | sed -E "s/\s+/ /g")
            # Output JSON for use with tools like Waybar or Polybar
            echo "{\"text\":\"$text\", \"tooltip\":\"$tooltip\"}"
            exit 0
        fi
    fi
    sleep 2
done

# Fallback error JSON if all 5 attempts fail
echo "{\"text\":\"error\", \"tooltip\":\"error\"}"
