#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
configuration="${1:-debug}"
case "$configuration" in debug|release) ;; *) echo "Use debug or release" >&2; exit 2;; esac
swift build -c "$configuration"
name=$(/usr/libexec/PlistBuddy -c 'Print CFBundleName' Resources/Info.plist)
bundle="$PWD/dist/$name.app"
mkdir -p "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
cp -X "$(swift build -c "$configuration" --show-bin-path)/LocalAssistant" "$bundle/Contents/MacOS/LocalAssistant"
cp -X Resources/Info.plist "$bundle/Contents/Info.plist"
if [[ -f Resources/AppIcon.icns ]]; then cp -X Resources/AppIcon.icns "$bundle/Contents/Resources/AppIcon.icns"; fi
if [[ -f Resources/MenuBarMark.pdf ]]; then cp -X Resources/MenuBarMark.pdf "$bundle/Contents/Resources/MenuBarMark.pdf"; fi
xattr -cr "$bundle"
if [[ -n "${SIGNING_IDENTITY:-}" ]]; then
  codesign --force --options runtime --timestamp --entitlements Resources/Release.entitlements --sign "$SIGNING_IDENTITY" "$bundle"
else
  codesign --force --sign - "$bundle"
fi
codesign --verify --strict "$bundle"
printf '%s
' "$bundle"
