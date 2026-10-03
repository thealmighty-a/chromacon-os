#!/usr/bin/env bash
# Default output for waybar. "switch" moves to the next sink (pactl / PipeWire-Pulse).
cur=$(pactl get-default-sink 2>/dev/null) || { echo '{"text": ""}'; exit 0; }
mapfile -t sinks < <(pactl -f json list sinks | jq -r '.[].name')
if [[ ${1:-} == switch ]]; then
  next=$cur
  for i in "${!sinks[@]}"; do
    [[ ${sinks[i]} == "$cur" ]] && next=${sinks[(i + 1) % ${#sinks[@]}]}
  done
  pactl set-default-sink "$next"
  cur=$next
fi
desc=$(pactl -f json list sinks | jq -r --arg n "$cur" '.[] | select(.name == $n) | .description')
short=${desc:0:24}
jq -nc --arg t "$short" --arg tip "Output: $desc (click to switch)" '{text: $t, tooltip: $tip}'
