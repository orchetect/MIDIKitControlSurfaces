//
//  MIDIHUIStateProtocol.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

public protocol MIDIHUIStateProtocol where Enum : MIDIHUIParameterProtocol {
    
    associatedtype Enum
    
    /// Read the state of a parameter.
    func state(of param: Enum) -> Bool
    
    /// Set the state of a parameter.
    mutating func setState(of param: Enum, to state: Bool)
    
}
