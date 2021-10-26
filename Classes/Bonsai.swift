//
//  Copyright © 2020 James Ruston. All rights reserved.
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
    
    public static func log(level: LogLevel, metadata: [AnyHashable: Any], file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldLog(level) else { return }

        drivers.forEach { $0.log(level: level, metadata, file: file, function: function, line: line) }
    }
    
    public static func store(_ params: [AnyHashable: Any]) {
        drivers.forEach { $0.store(params) }
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
        guard !(drivers.contains { $0 === driver }) else {
            return
        }
        drivers.append(driver)
    }
    
    static func resetDrivers() {
        drivers = []
        debugFocusEnabled = false
        minimumLogLevel = .verbose
    }
}

public protocol BonsaiDriver: AnyObject {
    func log(level: LogLevel, _ message: String, file: String, function: String, line: Int)
    func log(level: LogLevel, _ metadata: [AnyHashable: Any], file: String, function: String, line: Int)
    
    ///
    /// To be used when you want to access parameters on your Bonsai drivers
    /// - Example
    /// You may want to append this parameters to every log message, store them locally or
    /// even pass them to a service like Crasylytics/Firebase
    ///
    func store(_ params: [AnyHashable: Any])
}

public class ConsoleLogger: BonsaiDriver {
    
    public init() {}
    
    public func log(level: LogLevel, _ message: String, file: String, function: String, line: Int) {
        guard let fileName = file.split(separator: "/").last else { return }
        
        #if DEBUG
        print("[LOGGER] \(level.emoji) [\(fileName):\(line)] \(message)")
        #endif
    }
    
    public func log(level: LogLevel, _ metadata: [AnyHashable : Any], file: String, function: String, line: Int) {
        guard let fileName = file.split(separator: "/").last else { return }
        
        #if DEBUG
        print("[LOGGER] \(level.emoji) [\(fileName).\(line)]📓")

        for (key, value) in metadata {
            print("[LOGGER]\t\t\(key) = \(value)")
        }
        #endif
    }
    
    public func store(_ params: [AnyHashable : Any]) {}
}

@available(OSX 10.12, iOS 10.0, iOSApplicationExtension 10.0, watchOS 3.0, tvOS 10.0, *)
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
    
    func log(level: LogLevel, _ metadata: [AnyHashable : Any], file: String, function: String, line: Int) {
        log(level: level, metadata.description, file: file, function: function, line: line)
    }
    
    func store(_ params: [AnyHashable : Any]) {}
    
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
    
    func log(_ level: LogLevel = .verbose, file: String = #file, function: String = #function, line: Int = #line) {
        Bonsai.log(level: level, self, file: file, function: function, line: line)
    }
}

public extension Dictionary where Key == AnyHashable {
    func log(_ level: LogLevel = .verbose, file: String = #file, function: String = #function, line: Int = #line) {
        Bonsai.log(level: level, metadata: self, file: file, function: function, line: line)
    }
    
    func store() {
        Bonsai.store(self)
    }
}

public extension Error {
    func log(_ level: LogLevel = .warning, file: String = #file, function: String = #function, line: Int = #line) {
        Bonsai.log(level: level, "\(self)", file: file, function: function, line: line)
    }
}
