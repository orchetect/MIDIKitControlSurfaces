//
//  HUISurfaceView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    
    func TopView() -> some View {
        
        HStack {
            MeterBridgeView()
            LargeTextDisplayView()
        }
        .background(Color.black)
        
    }

    struct LevelMeterView: View {
        
        @EnvironmentObject var huiSurface: MIDI.HUI.Surface

        let channel: Int
        let side: MIDI.HUI.Surface.State.StereoLevelMeter.Side

        static let segmentIndexes = Array(
            stride(from: MIDI.HUI.Surface.State.StereoLevelMeter.levelMax,
                   through: MIDI.HUI.Surface.State.StereoLevelMeter.levelMin + 1,
                   by: -1)
        )

        var body: some View {
            VStack(alignment: .center, spacing: 1) {
                ForEach(Self.segmentIndexes, id: \.self) { segment in
                    Rectangle()
                        .fill(color(forSegment: segment))
                }
            }
            .background(Color(white: 0.25, opacity: 1.0))
        }

        func level() -> Int {
            huiSurface.state.channelStrips[channel].levelMeter.level(of: side)
        }

        func color(forSegment segment: Int) -> Color {
            segment < level() ? segmentColor(segment) : Color.black
        }

        func segmentColor(_ segment: Int) -> Color {
            switch segment {
            case 1 ... 8: return Color.green
            case 9 ... 11: return Color.yellow
            case 12: return Color.red
            default: return Color.black
            }
        }
        
    }

    func MeterBridgeView() -> some View {
        
        HStack(alignment: .center, spacing: 1) {
            ForEach(0 ..< 7 + 1, id: \.self) { channel in
                HStack(alignment: .center, spacing: 2) {
                    LevelMeterView(channel: channel, side: .left)
                        .frame(width: 10, height: 100)
                    LevelMeterView(channel: channel, side: .right)
                        .frame(width: 10, height: 100)
                }
                .frame(width: 40, height: 100, alignment: .center)
                .border(Color.black)
                .frame(width: 60)
            }
        }
        
    }

    func LargeTextDisplayView() -> some View {
        
        VStack(alignment: .leading, spacing: 5) {
            // Text(String(repeating: "0", count: 40))
            // Text(String(repeating: "0", count: 40))
            Text(huiSurface.state.largeDisplay.topStringValue)
            Text(huiSurface.state.largeDisplay.bottomStringValue)
        }
        .font(.system(size: 14, weight: .regular, design: .monospaced))
        .foregroundColor(Color.white)
        .frame(width: 360, height: 42)
        .background(Color.black)
        .cornerRadius(3.0, antialiased: true)
        
    }

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

            Spacer().frame(width: 5, height: 1)

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
