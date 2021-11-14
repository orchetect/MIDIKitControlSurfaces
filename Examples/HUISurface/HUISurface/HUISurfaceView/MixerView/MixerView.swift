//
//  MixerView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    
    func MixerView() -> some View {
        
        VStack {
            HStack(alignment: .center, spacing: 1) {
                ForEach(0 ..< 7 + 1, id: \.self) { channel in
                    ChannelStripView(channel: channel)
                        .frame(width: Self.channelStripWidth, alignment: .center)
                }
            }
            Spacer()
        }
        
    }
    
}
