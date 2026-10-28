#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
iconset=".build/icons/AppIcon.iconset"
catalog="Resources/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$iconset" "$catalog" .build/icons/previews
for size in 16 32 128 256 512; do
  sips -z "$size" "$size" Resources/AppIcon-source.png --out "$iconset/icon_${size}x${size}.png" >/dev/null
  double=$((size * 2))
  sips -z "$double" "$double" Resources/AppIcon-source.png --out "$iconset/icon_${size}x${size}@2x.png" >/dev/null
  cp -X "$iconset/icon_${size}x${size}.png" "$catalog/icon_${size}x${size}.png"
  cp -X "$iconset/icon_${size}x${size}@2x.png" "$catalog/icon_${size}x${size}@2x.png"
done
{
  printf '{"images":['
  separator=""
  for size in 16 32 128 256 512; do
    for scale in 1 2; do
      suffix=""; if [[ "$scale" == 2 ]]; then suffix="@2x"; fi
      printf '%s{"idiom":"mac","size":"%sx%s","scale":"%sx","filename":"icon_%sx%s%s.png"}' "$separator" "$size" "$size" "$scale" "$size" "$size" "$suffix"
      separator=","
    done
  done
  printf '],"info":{"author":"xcode","version":1}}\n'
} > "$catalog/Contents.json"
iconutil -c icns "$iconset" -o Resources/AppIcon.icns
sips -z 256 256 Resources/AppIcon-source.png --out Resources/AppIcon.png >/dev/null
swiftc -parse-as-library scripts/render_mark.swift -o .build/icons/render_mark
.build/icons/render_mark docs/brand/pebble-mono.svg Resources/MenuBarMark.pdf .build/icons/previews
