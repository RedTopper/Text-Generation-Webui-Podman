#!/bin/bash

set -Eeuo pipefail

declare -A LINKS

LINKS["/app/loras"]="/data/loras"
LINKS["/app/models"]="/data/models"
LINKS["/app/softprompts"]="/data/softprompts"
LINKS["/app/characters"]="/data/characters"

LINKS["/app/logs"]="/output/logs"

LINKS["/app/extensions/silero_tts/outputs"]="/output/silero_tts"
LINKS["/app/extensions/elevenlabs_tts/outputs"]="/output/elevenlabs_tts"
LINKS["/app/extensions/sd_api_pictures/outputs"]="/output/sd_api_pictures"

for app_path in "${!LINKS[@]}"; do
  data_path="${LINKS[${app_path}]}"
  [ -d "$data_path" ] || mkdir -vp "$data_path"
  [ -d "$app_path" ] || mkdir -vp "$app_path"
  cp -rn $app_path/. $data_path
  rm -r $app_path
  ln -sT "${data_path}" "${app_path}"
  echo Linked $(basename "${app_path}")
done

exec "$@"
