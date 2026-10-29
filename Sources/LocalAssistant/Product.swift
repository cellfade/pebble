import Foundation
enum Product {
    #if APP_STORE
    static let isAppStoreBuild = true
    #else
    static let isAppStoreBuild = false
    #endif
    static let name = "Pebble"
    static let version = isAppStoreBuild ? "0.3.0" : "0.3.0-beta.2"
    static let editionLabel = isAppStoreBuild ? "On-device edition" : "Developer preview"
    static let privacyURL = URL(string: "https://github.com/cellfade/pebble/blob/main/docs/PRIVACY.md")!
    static let supportURL = URL(string: "https://github.com/cellfade/pebble/issues")!
    static let tagline = "A little help. Close to home."
    static let ollamaURL = URL(string: "https://ollama.com/download/mac")!
}
