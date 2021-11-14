//
//  MainTimeDisplayView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    
    func MainTimeDisplayView() -> some View {
        
        HStack {
            VStack(alignment: .trailing, spacing: 4) {
                Text("TIME CODE "
                     + (huiSurface.state.timeDisplay.timecode ? "🔴" : "⚪️"))
                Text("FEET "
                     + (huiSurface.state.timeDisplay.feet ? "🔴" : "⚪️"))
                Text("BEATS "
                     + (huiSurface.state.timeDisplay.beats ? "🔴" : "⚪️"))
            }
            .font(.system(size: 9, weight: .regular))
            
            Text(huiSurface.state.timeDisplay.stringValue
                 // .split(every: 2).joined(separator: " ")
            )
                .font(.system(size: 20, weight: .regular, design: .monospaced))
                .foregroundColor(Color.red)
                .frame(width: 150, height: 30)
                .background(Color.black)
                .cornerRadius(3.0, antialiased: true)
            
            Spacer().frame(width: 20)
            
            HStack {
                VStack(alignment: .trailing, spacing: 1) {
                    Text("RUDE")
                    Text("SOLO")
                    Text("LIGHT")
                }
                .font(.system(size: 9, weight: .regular))
                
                Text(huiSurface.state.timeDisplay.rudeSolo ? "🔴" : "⚪️")
                    .font(.system(size: 14))
            }
        }
        
    }
    
}
