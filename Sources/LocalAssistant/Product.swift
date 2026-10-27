import Foundation
enum Product {
    #if APP_STORE
    static let isAppStoreBuild = true
    #else
    static let isAppStoreBuild = false
    #endif
    static let name = "Pebble"
    static let version = "0.2.0"
    static let tagline = "A little help. Close to home."
    static let ollamaURL = URL(string: "https://ollama.com/download/mac")!
}
