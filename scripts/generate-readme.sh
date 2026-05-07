#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
JSON_FILE="${PROJECT_ROOT}/data/tech-stack.json"

if [ ! -f "$JSON_FILE" ]; then
  echo "Error: $JSON_FILE not found"
  exit 1
fi

map_language_to_icons() {
  local lang=$1
  case "$lang" in
    typescript) echo "typescript";;
    javascript) echo "js";;
    rust) echo "rust";;
    python) echo "python";;
    nix) echo "nix";;
    go) echo "go";;
    shell) echo "bash";;
    html) echo "html";;
    css) echo "css";;
    java) echo "java";;
    c) echo "c";;
    cpp) echo "cpp";;
    ruby) echo "ruby";;
    php) echo "php";;
    swift) echo "swift";;
    kotlin) echo "kotlin";;
    dockerfile) echo "docker";;
    terraform) echo "terraform";;
    vue) echo "vue";;
    svelte) echo "svelte";;
    lua) echo "lua";;
    zig) echo "zig";;
    *) echo "";;
  esac
}

LANGUAGES=$(jq -r '.languages[]' "$JSON_FILE" 2>/dev/null || echo "")

if [ -z "$LANGUAGES" ]; then
  echo "No languages found in JSON"
  exit 1
fi

ICONS=""
for lang in $LANGUAGES; do
  icon=$(map_language_to_icons "$lang")
  if [ -n "$icon" ]; then
    if [ -n "$ICONS" ]; then
      ICONS="${ICONS},${icon}"
    else
      ICONS="$icon"
    fi
  fi
done

echo "Generated icons: $ICONS"

TOOLS="linux,git,github,vscode,docker"
ALL_ICONS="${ICONS},${TOOLS}"

sed -i "s|align=\"center\">\n    <img src=\"https://skillicons.dev/icons?i=.*&perline=.*\" alt=\"Tech Stack\" />|align=\"center\">\n    <img src=\"https://skillicons.dev/icons?i=${ALL_ICONS}&perline=6&theme=dark\" alt=\"Tech Stack\" />|g" "${PROJECT_ROOT}/README.md"

echo "README updated successfully"