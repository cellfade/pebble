#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/checks
swiftc -parse-as-library \
  Sources/LocalAssistant/Product.swift \
  Sources/LocalAssistant/ClockService.swift \
  Sources/LocalAssistant/ActionModels.swift \
  Sources/LocalAssistant/AppleModelClient.swift \
  Sources/LocalAssistant/AssistantStore.swift \
  Sources/LocalAssistant/OllamaClient.swift \
  Sources/LocalAssistant/ImageAttachment.swift \
  Tests/BetaChecks.swift \
  -o .build/checks/BetaChecks
.build/checks/BetaChecks
