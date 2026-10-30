#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
: "${TEAM_ID:?Set TEAM_ID to your Apple Developer team identifier}"
if ! xcodebuild -version >/dev/null 2>&1; then echo 'Full Xcode 26+ is required; Command Line Tools alone cannot archive an App Store app.' >&2; exit 1; fi
xcode_version=$(xcodebuild -version | awk '/^Xcode / {print $2}')
[[ "${xcode_version%%.*}" -ge 26 ]] || { echo 'Select stable Xcode 26+ with DEVELOPER_DIR.' >&2; exit 1; }
xcodebuild -project Pebble.xcodeproj -scheme Pebble -configuration AppStore -destination 'generic/platform=macOS' -archivePath "$PWD/dist/Pebble.xcarchive" DEVELOPMENT_TEAM="$TEAM_ID" archive
printf 'Archive created. Validate and distribute through Xcode Organizer after reviewing App Store metadata and privacy answers.
'
