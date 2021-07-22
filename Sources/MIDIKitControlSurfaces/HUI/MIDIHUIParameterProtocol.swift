//
//  MIDIHUIParameterProtocol.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

public protocol MIDIHUIParameterProtocol {
    
    /// HUI zone and port constant for the parameter
    @inlinable var zoneAndPort: MIDI.HUI.ZoneAndPortPair { get }
    
}
