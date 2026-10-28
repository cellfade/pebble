#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")/.."
mkdir -p .build/smoke
swiftc -parse-as-library Sources/LocalAssistant/ClockService.swift Sources/LocalAssistant/ActionModels.swift Sources/LocalAssistant/Product.swift Sources/LocalAssistant/AppleModelClient.swift Sources/LocalAssistant/AssistantStore.swift Sources/LocalAssistant/OllamaClient.swift Sources/LocalAssistant/ImageAttachment.swift Sources/LocalAssistant/PromptEditor.swift Tests/ClientSmoke.swift -o .build/smoke/ClientSmoke
.build/smoke/ClientSmoke
