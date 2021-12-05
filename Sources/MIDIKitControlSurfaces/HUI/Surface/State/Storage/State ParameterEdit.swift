//
//  State ParameterEdit.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI.Surface.State {
    
    /// State storage representing the Parameter Edit section
    public struct ParameterEdit: Equatable, Hashable {
        
        public var assign = false
        public var compare = false
        public var bypass = false
        
        public var param1Select = false
        public var param1VPotLevel: MIDI.UInt7 = 0
        
        public var param2Select = false
        public var param2VPotLevel: MIDI.UInt7 = 0
        
        public var param3Select = false
        public var param3VPotLevel: MIDI.UInt7 = 0
        
        public var param4Select = false
        public var param4VPotLevel: MIDI.UInt7 = 0
        
        /// Toggle: Insert (off) / Param (on)
        public var insertOrParam = false
        
    }
    
}

extension MIDI.HUI.Surface.State.ParameterEdit: MIDIHUIStateProtocol {
    
    public typealias Enum = MIDI.HUI.Parameter.ParameterEdit

    public func state(of param: Enum) -> Bool {
        
        switch param {
        case .assign:         return assign
        case .compare:        return compare
        case .bypass:         return bypass
        case .param1Select:   return param1Select
        case .param2Select:   return param2Select
        case .param3Select:   return param3Select
        case .param4Select:   return param4Select
        case .insertOrParam:  return insertOrParam
        }
        
    }
    
    public mutating func setState(of param: Enum, to state: Bool) {
        
        switch param {
        case .assign:         assign = state
        case .compare:        compare = state
        case .bypass:         bypass = state
        case .param1Select:   param1Select = state
        case .param2Select:   param2Select = state
        case .param3Select:   param3Select = state
        case .param4Select:   param4Select = state
        case .insertOrParam:  insertOrParam = state
        }
        
    }
    
}
