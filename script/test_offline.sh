#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/checks
swiftc -parse-as-library Sources/LocalAssistant/Product.swift Sources/LocalAssistant/AppleModelClient.swift Sources/LocalAssistant/AssistantStore.swift Sources/LocalAssistant/OllamaClient.swift Sources/LocalAssistant/ImageAttachment.swift Sources/LocalAssistant/PromptEditor.swift Tests/OfflineChecks.swift -o .build/checks/OfflineChecks
.build/checks/OfflineChecks
