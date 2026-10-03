#!/usr/bin/env bash
# Current Spotify track for waybar (playerctl). Empty when Spotify isn't running.
status=$(playerctl -p spotify status 2>/dev/null) || { echo '{"text": ""}'; exit 0; }
artist=$(playerctl -p spotify metadata artist 2>/dev/null)
title=$(playerctl -p spotify metadata title 2>/dev/null)
if [[ $status == Playing ]]; then mark=">"; else mark="||"; fi
jq -nc --arg t "$mark $artist - $title" --arg tip "$status: $artist - $title" --arg c "${status,,}" \
  '{text: $t, tooltip: $tip, class: $c}'
