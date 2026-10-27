#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${TEAM_ID:?Set TEAM_ID to your Apple Developer team identifier}"
if ! xcodebuild -version >/dev/null 2>&1; then echo 'Full Xcode 26+ is required; Command Line Tools alone cannot archive an App Store app.' >&2; exit 1; fi
xcodebuild -project Pebble.xcodeproj -scheme Pebble -configuration AppStore -destination 'generic/platform=macOS' -archivePath "$PWD/dist/Pebble.xcarchive" DEVELOPMENT_TEAM="$TEAM_ID" archive
printf 'Archive created. Validate and distribute through Xcode Organizer after reviewing App Store metadata and privacy answers.
'
