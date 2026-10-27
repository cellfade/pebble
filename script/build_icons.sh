#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/icons/AppIcon.iconset
for size in 16 32 128 256 512; do
  sips -z "$size" "$size" Resources/AppIcon-source.png --out ".build/icons/AppIcon.iconset/icon_${size}x${size}.png" >/dev/null
  double=$((size * 2))
  sips -z "$double" "$double" Resources/AppIcon-source.png --out ".build/icons/AppIcon.iconset/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns .build/icons/AppIcon.iconset -o Resources/AppIcon.icns
sips -z 256 256 Resources/AppIcon-source.png --out Resources/AppIcon.png >/dev/null
swiftc -parse-as-library scripts/render_mark.swift -o .build/icons/render_mark
.build/icons/render_mark Resources/MenuBarMark.pdf
