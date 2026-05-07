#!/bin/bash
set -e

USERNAME="MythEclipse"
OUTPUT_FILE="data/tech-stack.json"

fetch_languages() {
  local languages=$(curl -s "https://api.github.com/users/${USERNAME}/repos?per_page=100&sort=updated" | \
    jq -r '[.[] | select(.language != null) | .language] | unique | map(tolower)' 2>/dev/null || echo "[]")
  
  local top_langs=$(curl -s "https://github-readme-stats.vercel.app/api/top-langs/?username=${USERNAME}&layout=compact&theme=tokyonight&hide_border=false&bg_color=1a1b26&title_color=06b6d4")
  
  echo "{\"updated\":\"$(date -Iseconds)\",\"username\":\"${USERNAME}\",\"languages\":${languages},\"stats_url\":\"${top_langs}\"}" > "${OUTPUT_FILE}"
  echo "Updated: ${OUTPUT_FILE}"
}

fetch_languages