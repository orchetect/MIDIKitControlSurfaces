//
//  Surface Event ParamEditComponent.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

extension MIDI.HUI.Surface.Event {
    
    /// A discrete component of a the param edit section and it state/value.
    public enum ParamEditComponent: Equatable, Hashable {
        
        case assign(Bool)
        case compare(Bool)
        case bypass(Bool)
        
        case param1Select(Bool)
        case param1VPotLevel(MIDI.UInt7)
        
        case param2Select(Bool)
        case param2VPotLevel(MIDI.UInt7)
        
        case param3Select(Bool)
        case param3VPotLevel(MIDI.UInt7)
        
        case param4Select(Bool)
        case param4VPotLevel(MIDI.UInt7)
        
        case insertOrParam(Bool)
        
    }
    
}
