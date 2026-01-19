import Foundation
import os

enum AppLogger {
    private static let subsystem = Bundle.main.bundleIdentifier ?? "com.practicum.FakeNFT"
    
    enum Category: String {
        case statistic = "Statistic"
        case profile = "Profile"
        case cart = "Cart"
        case catalog = "Catalog"
        
        case network = "Network"
        case storage = "Storage"
        case ui = "UI"
        case general = "General"
    }
    
    static func logger (for category: Category) -> Logger {
        return Logger(subsystem: subsystem, category: category.rawValue)
    }
    
    static func debug(_ message: String,category: Category = .general) {
        logger(for: category).debug("\(message)")
    }
    
    static func info(_ message: String, category: Category = .general) {
        logger(for: category).info("\(message)")
    }
    
    static func notice(_ message: String, category: Category = .general) {
        logger(for: category).notice("\(message)")
    }
    
    static func error(_ message: String, category: Category = .general) {
        logger(for: category).error("\(message)")
    }
    
    static func critical(_ message: String, category: Category = .general) {
        logger(for: category).critical("\(message)")
    }
}
