#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
./script/build_app.sh release
name=$(/usr/libexec/PlistBuddy -c 'Print CFBundleName' Resources/Info.plist)
version=$(/usr/libexec/PlistBuddy -c 'Print CFBundleShortVersionString' Resources/Info.plist)
arch=$(uname -m)
slug="${name// /-}"
channel="${RELEASE_CHANNEL:-preview}"
[[ "$channel" =~ ^[A-Za-z0-9.-]+$ ]] || { echo "Invalid RELEASE_CHANNEL" >&2; exit 2; }
archive="dist/$slug-$version-$arch-$channel.zip"
ditto -c -k --noextattr --norsrc --keepParent "dist/$name.app" "$archive"
if [[ -n "${NOTARY_PROFILE:-}" ]]; then
  [[ -n "${SIGNING_IDENTITY:-}" ]] || { echo "Notarization requires SIGNING_IDENTITY" >&2; exit 1; }
  xcrun notarytool submit "$archive" --keychain-profile "$NOTARY_PROFILE" --wait
  xcrun stapler staple "dist/$name.app"
  xcrun stapler validate "dist/$name.app"
  archive="dist/$slug-$version-$arch.zip"
  ditto -c -k --noextattr --norsrc --keepParent "dist/$name.app" "$archive"
fi
(cd dist && shasum -a 256 "$(basename "$archive")") > "$archive.sha256"
printf '%s
' "$archive"
