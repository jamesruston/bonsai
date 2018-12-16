//
//  Copyright © 2018 John Crossley. All rights reserved.
//

import Foundation
import os

public enum LogLevel: Int {
    case verbose
    case debug
    case warning
    case error
    
    var emoji: String {
        switch self {
        case .verbose: return "🤫"
        case .debug: return "👷🏻‍♀️" // these should only be used during debugging and either removed or changed to verbose after
        case .warning: return "⚠️"
        case .error: return "🔥"
        }
    }
}

public class Bonsai {
    
    public private(set) static var drivers = [BonsaiDriver]()
    public static var minimumLogLevel = LogLevel.verbose
    public static var debugFocusEnabled = false
    
    public static func log(_ level: LogLevel, _ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldLog(level) else { return }
        
        drivers.forEach { $0.log(level: level, message, file: file, function: function, line: line) }
    }
    
    fileprivate static func log(level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        guard shouldLog(level) else { return }
        
        drivers.forEach { $0.log(level: level, message, file: file, function: function, line: line) }
    }
    
    private static func shouldLog(_ level: LogLevel) -> Bool {
        if debugFocusEnabled {
            return level == .debug
        }
        return level.rawValue >= minimumLogLevel.rawValue
    }
    
    public static func register(driver: BonsaiDriver) {
        guard !(drivers.contains { $0 === driver }) else { return }
        drivers.append(driver)
    }
    
    static func resetDrivers() {
        drivers = []
        debugFocusEnabled = false
        minimumLogLevel = .verbose
    }
}

public protocol BonsaiDriver: class {
    func log(level: LogLevel, _ message: String, file: String, function: String, line: Int)
}

public class ConsoleLogger: BonsaiDriver {
    
    public init() {}
    
    public func log(level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        guard let fileName = file.split(separator: "/").last else { return }
        
        #if DEBUG
        print("[LOGGER] \(level.emoji) [\(fileName).\(line)]: \(message)")
        #endif
    }
}

class OSLogger: BonsaiDriver {
    private let oslog: OSLog
    
    init(subsystem: String, category: String) {
        oslog = OSLog(subsystem: subsystem, category: category)
    }
    
    func log(level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        let msg = "\(level.emoji) \(message)"
        os_log("[LOGGER] %@.%@:%i - \n%@",
               log: oslog,
               type: osLogLevel(from: level),
               file, function, line, msg)
    }
    
    private func osLogLevel(from level: LogLevel) -> OSLogType {
        switch level {
        case .verbose: return .info
        case .debug: return .debug
        case .warning: return .error
        case .error: return .fault
        }
    }
}

public extension String {
    
    public func log(_ level: LogLevel, file: String = #file, function: String = #function, line: Int = #line) {
        Bonsai.log(level: level, self, file: file, function: function, line: line)
    }
}
