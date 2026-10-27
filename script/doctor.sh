#!/bin/bash
set -euo pipefail
printf 'macOS: '; sw_vers -productVersion
printf 'Architecture: '; uname -m
printf 'Ollama: '; if command -v ollama >/dev/null; then ollama --version; else echo 'CLI not found; install/open Ollama from https://ollama.com/download/mac'; fi
printf 'Local endpoint: '
curl --noproxy '*' --fail --silent --show-error --max-time 8 http://127.0.0.1:11434/api/version
printf '
Installed models: '
curl --noproxy '*' --fail --silent --show-error --max-time 8 http://127.0.0.1:11434/api/tags
printf '
'
