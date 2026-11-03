#!/usr/bin/env bash
set -euo pipefail

WALLPAPER="${1:-}"
if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    if [ -f "$HOME/.cache/current_wallpaper" ]; then
        WALLPAPER="$HOME/.cache/current_wallpaper"
    elif [ -f "$HOME/.local/state/quickshell/wallpaper.json" ]; then
        WALLPAPER=$(jq -r '.path // empty' "$HOME/.local/state/quickshell/wallpaper.json" 2>/dev/null || true)
    fi
fi

if [ -z "$WALLPAPER" ] || [ ! -f "$WALLPAPER" ]; then
    exit 0
fi

OUTPUT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$OUTPUT_DIR/hyprlock.png"

# Obtener dimensiones de la imagen
read -r W H <<< "$(magick identify -format "%w %h" "$WALLPAPER" 2>/dev/null || echo "2560 1440")"

# Ancho de la franja desenfocada a la izquierda (25% del ancho o mínimo 560px)
STRIP_W=$(( W / 4 ))
if [ "$STRIP_W" -lt 560 ]; then
    STRIP_W=560
fi

# Aplicar desenfoque exclusivamente a la franja izquierda
magick "$WALLPAPER" -region "${STRIP_W}x${H}+0+0" -blur 0x20 "$OUTPUT_FILE"
