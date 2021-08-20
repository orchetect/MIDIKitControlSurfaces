//
//  HUI Parameter Wrapper.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation
import SwiftUI
import MIDIKitControlSurfaces

extension MIDI.HUI.Parameter {
    /// Because SwiftUI is a literal garbage and wants to crash constantly for no reason.
    /// The workaround is to make a class wrapper for MIDI.HUI.Parameter instance storage in a SwiftUI View. That prevents SwiftUI from attempting to compare the stored enum instance when recalculating the view during runtime and resulting in inexplicable crashes.
    ///
    /// References:
    /// - [SwiftUI Crash in AG::LayoutDescriptor::compare](https://noahgilmore.com/blog/swiftui-equatable-crash/)
    /// - [Twitter Thread](https://twitter.com/orchetect/status/1416871188723224577)
    class Wrapper {
        
        let wrapped: MIDI.HUI.Parameter

        init(_ wrapped: MIDI.HUI.Parameter) {
            
            self.wrapped = wrapped
            
        }
        
    }
}
