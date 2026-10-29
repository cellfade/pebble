#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
if ! xcodebuild -version >/dev/null 2>&1; then
  echo 'Full Xcode 26+ is required for archive validation.' >&2; exit 1
fi
xcode_version=$(xcodebuild -version | awk '/^Xcode / {print $2}')
[[ "${xcode_version%%.*}" -ge 26 ]] || { echo 'Select stable Xcode 26+ with DEVELOPER_DIR.' >&2; exit 1; }
archive="$PWD/dist/Pebble-Unsigned.xcarchive"
xcodebuild -project Pebble.xcodeproj -scheme Pebble -configuration AppStore \
  -destination 'generic/platform=macOS' -archivePath "$archive" \
  -derivedDataPath "$PWD/dist/StoreDerivedData" ARCHS=arm64 ONLY_ACTIVE_ARCH=NO \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY='' archive
python3 script/check_store_archive.py "$archive"
echo 'Unsigned Store archive validated. Signing, provisioning, Organizer validation and submission remain separate gates.'
