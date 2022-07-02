//
//  Logger.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import os.log

internal enum Logger {
    
    /// Prints a message to the console log. (`os_log`).
    /// Only outputs to log in a `DEBUG` build.
    @inline(__always)
    internal static func debug(_ message: String) {
        
        #if DEBUG
        if #available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *) {
            os_log("%{public}@",
                   log: OSLog.default,
                   type: .debug,
                   "HUI: " + message)
        } else {
            print(message)
        }
        #endif
        
    }
    
}
