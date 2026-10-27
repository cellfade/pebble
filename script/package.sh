#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
./script/build_app.sh release
name=$(/usr/libexec/PlistBuddy -c 'Print CFBundleName' Resources/Info.plist)
version=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' Resources/Info.plist)
arch=$(uname -m)
slug="${name// /-}"
archive="dist/$slug-$version-$arch-preview.zip"
ditto -c -k --noextattr --norsrc --keepParent "dist/$name.app" "$archive"
if [[ -n "${NOTARY_PROFILE:-}" ]]; then
  [[ -n "${SIGNING_IDENTITY:-}" ]] || { echo "Notarization requires SIGNING_IDENTITY" >&2; exit 1; }
  xcrun notarytool submit "$archive" --keychain-profile "$NOTARY_PROFILE" --wait
  xcrun stapler staple "dist/$name.app"
  xcrun stapler validate "dist/$name.app"
  archive="dist/$slug-$version-$arch.zip"
  ditto -c -k --noextattr --norsrc --keepParent "dist/$name.app" "$archive"
fi
shasum -a 256 "$archive" > "$archive.sha256"
printf '%s
' "$archive"
