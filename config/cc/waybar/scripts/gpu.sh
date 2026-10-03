#!/usr/bin/env bash
# GPU load for waybar. NVIDIA via nvidia-smi, AMD via sysfs. Hidden when neither is readable (Intel iGPUs have no busy counter).
if command -v nvidia-smi >/dev/null 2>&1; then
  read -r util temp <<<"$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ' | tr ',' ' ')"
  if [[ -n ${util:-} ]]; then
    jq -nc --arg t "GPU ${util}%" --arg tip "GPU ${util}%  ${temp}°C" '{text: $t, tooltip: $tip}'
    exit 0
  fi
fi
for f in /sys/class/drm/card*/device/gpu_busy_percent; do
  [[ -r $f ]] || continue
  busy=$(cat "$f")
  jq -nc --arg t "GPU ${busy}%" --arg tip "GPU ${busy}%" '{text: $t, tooltip: $tip}'
  exit 0
done
echo '{"text": ""}'
