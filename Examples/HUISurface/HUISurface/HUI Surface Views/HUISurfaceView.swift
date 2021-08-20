//
//  HUISurfaceView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

struct HUISurfaceView: View {
    
    @EnvironmentObject var huiSurface: MIDI.HUI.Surface

    var body: some View {
        VStack {
            TopView()

            HStack {
                MixerView()

                Spacer().frame(width: 84, height: 1)

                MainTimeDisplayView()
            }
        }
    }
    
}
