#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
configuration="${1:-debug}"
case "$configuration" in debug|release) ;; *) echo "Use debug or release" >&2; exit 2;; esac
swift build -c "$configuration"
name=$(/usr/libexec/PlistBuddy -c 'Print CFBundleName' Resources/Info.plist)
destination="$PWD/dist/$name.app"
staging=$(mktemp -d "${TMPDIR:-/tmp}/pebble-sign.XXXXXX")
trap 'rm -rf "$staging"' EXIT
bundle="$staging/$name.app"
mkdir -p "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
cp -X "$(swift build -c "$configuration" --show-bin-path)/LocalAssistant" "$bundle/Contents/MacOS/LocalAssistant"
cp -X Resources/Info.plist "$bundle/Contents/Info.plist"
if [[ -f Resources/AppIcon.icns ]]; then cp -X Resources/AppIcon.icns "$bundle/Contents/Resources/AppIcon.icns"; fi
if [[ -f Resources/AppIcon.png ]]; then cp -X Resources/AppIcon.png "$bundle/Contents/Resources/AppIcon.png"; fi
if [[ -f Resources/MenuBarMark.pdf ]]; then cp -X Resources/MenuBarMark.pdf "$bundle/Contents/Resources/MenuBarMark.pdf"; fi
cp -X Resources/PrivacyInfo.xcprivacy "$bundle/Contents/Resources/PrivacyInfo.xcprivacy"
xattr -cr "$bundle"
if [[ -n "${SIGNING_IDENTITY:-}" ]]; then
  codesign --force --options runtime --timestamp --entitlements Resources/Release.entitlements --sign "$SIGNING_IDENTITY" "$bundle"
else
  codesign --force --entitlements Resources/Release.entitlements --sign - "$bundle"
fi
codesign --verify --strict "$bundle"
mkdir -p dist
ditto --noextattr --norsrc "$bundle" "$destination"
printf '%s\n' "$destination"
