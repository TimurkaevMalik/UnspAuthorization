//
//  OSLogger.swift
//  UnspAuthoriztion
//
//  Created by Malik Timurkaev on 28.09.2025.
//

import OSLog

///TODO: move to a separate module
protocol Logging {
    typealias LogMessage = () -> String
    
    func log( _ message: @autoclosure @escaping LogMessage, level: LogLevel)
    func debug(_ message: @autoclosure @escaping LogMessage)
    func info(_ message: @autoclosure @escaping LogMessage)
    func notice(_ message: @autoclosure @escaping LogMessage)
    func error(_ message: @autoclosure @escaping LogMessage)
    func fault(_ message: @autoclosure @escaping LogMessage)
}

protocol LoggerSink {
    func record(_ message: @autoclosure @escaping () -> String, level: LogLevel)
}

final class OSLogAdapter: LoggerSink {
    private let logger: Logger
    
    init(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }
    
    func record(_ message: @autoclosure @escaping () -> String, level: LogLevel) {
        
        logger.log(level: level.osType, "\(message())")
    }
}

final class MultiplexLogger: Logging {
    
    private let logLevel: LogLevel = {
#if DEBUG
        .debug
#else
        .error
#endif
    }()
    
    private let loggers: [LoggerSink]
    
    init(loggers: [LoggerSink]) {
        self.loggers = loggers
    }
    
    func log(_ message: @autoclosure @escaping () -> String, level: LogLevel) {
        guard level >= logLevel else { return }
        loggers.forEach({ $0.record(message(), level: level) })
    }
    
    func debug(_ message: @autoclosure @escaping () -> String) {
        log(message(), level: .debug)
    }
    
    func info(_ message: @autoclosure @escaping () -> String) {
        log(message(), level: .info)
    }
    
    func notice(_ message: @autoclosure @escaping () -> String) {
        log(message(), level: .notice)
    }
    
    func error(_ message: @autoclosure @escaping () -> String) {
        log(message(), level: .error)
    }
    
    func fault(_ message: @autoclosure @escaping () -> String) {
        log(message(), level: .fault)
    }
}

enum LogLevel: Int {
    case debug, info, notice, error, fault
    
    var osType: OSLogType {
        switch self {
        case .debug:
                .debug
        case .info:
                .info
        case .notice:
                .default
        case .error:
                .error
        case .fault:
                .fault
        }
    }
}

extension LogLevel: Comparable {
    static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
