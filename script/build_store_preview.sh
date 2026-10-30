#!/bin/bash
# Local Store-conditional UI test bundle. Not an Xcode archive or upload artifact.
set -euo pipefail
cd "$(dirname "$0")/.."
staging=$(mktemp -d "${TMPDIR:-/tmp}/pebble-store-preview.XXXXXX")
trap 'rm -rf "$staging"' EXIT
bundle="$staging/Pebble.app"
mkdir -p "$bundle/Contents/MacOS" "$bundle/Contents/Resources"
ditto --noextattr --norsrc Sources/LocalAssistant "$staging/Sources"
# Compile a stable source snapshot outside FileProvider-managed Documents.
swiftc -swift-version 5 -DAPP_STORE -target arm64-apple-macos26.0 -parse-as-library \
  "$staging"/Sources/*.swift -o "$bundle/Contents/MacOS/LocalAssistant"
cp -X Resources/Store-Info.plist "$bundle/Contents/Info.plist"
for resource in AppIcon.icns AppIcon.png MenuBarMark.pdf PrivacyInfo.xcprivacy; do
  cp -X "Resources/$resource" "$bundle/Contents/Resources/$resource"
done
xattr -cr "$bundle"
codesign --force --entitlements Resources/AppStore.entitlements --sign - "$bundle"
codesign --verify --strict "$bundle"
mkdir -p dist/StorePreview
ditto --noextattr --norsrc "$bundle" dist/StorePreview/Pebble.app
printf '%s\n' "$PWD/dist/StorePreview/Pebble.app"
