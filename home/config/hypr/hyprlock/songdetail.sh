#!/bin/bash

song_info=$(playerctl metadata --format '{{title}}  •  {{artist}}' 2>/dev/null || true)

echo "$song_info" 
