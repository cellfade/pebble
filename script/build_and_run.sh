#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mode="${1:-run}"
case "$mode" in run|--debug|--logs|--telemetry|--verify) ;; *) echo "usage: $0 [--debug|--logs|--telemetry|--verify]"; exit 2;; esac
pkill -x LocalAssistant >/dev/null 2>&1 || true
./script/build_app.sh debug
name=$(/usr/libexec/PlistBuddy -c 'Print CFBundleName' Resources/Info.plist)
bundle="$PWD/dist/$name.app"
if [[ "$mode" == --debug ]]; then exec lldb -- "$bundle/Contents/MacOS/LocalAssistant"; fi
open -n "$bundle"
case "$mode" in
--verify) sleep 1; pgrep -x LocalAssistant ;;
--logs|--telemetry) /usr/bin/log stream --info --style compact --predicate 'process == "LocalAssistant"' ;;
esac
