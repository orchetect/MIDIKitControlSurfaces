//
//  HUISurfaceView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

extension HUISurfaceView {
    
    static let channelStripWidth: CGFloat = 60

    func MixerView() -> some View {
        
        HStack(alignment: .center, spacing: 1) {
            ForEach(0 ..< 7 + 1, id: \.self) { channel in
                ChannelStripView(channel: channel)
                    .frame(width: Self.channelStripWidth, alignment: .center)
            }
        }
        
    }

    struct ChannelStripView: View {
        
        @EnvironmentObject var huiSurface: MIDI.HUI.Surface

        let channel: Int

        var body: some View {
            VStack(alignment: .center, spacing: 10) {
                Group {
                    HUIStateButton("REC/RDY",
                                   .channelStrip(channel, .recordReady),
                                   .red)

                    HUIStateButton("INSERT",
                                   .channelStrip(channel, .insert),
                                   .green)

                    HUIStateButton("V-SEL",
                                   .channelStrip(channel, .vPotSelect),
                                   .yellow)
                }

                Circle() // "PAN/SEND"
                    .fill(Color.gray)
                    .frame(height: 40)

                Group {
                    HUIStateButton("AUTO",
                                   .channelStrip(channel, .auto),
                                   .red)

                    HUIStateButton("SOLO",
                                   .channelStrip(channel, .solo),
                                   .green)

                    HUIStateButton("MUTE",
                                   .channelStrip(channel, .mute),
                                   .red)
                }

                Group {
                    Text(huiSurface.state.channelStrips[channel].nameTextDisplay)
                        .font(.system(size: 16, weight: .regular, design: .monospaced))
                        .foregroundColor(Color.green)
                        .frame(maxWidth: .infinity)
                        .frame(height: 26)
                        .background(Color.black)
                        .cornerRadius(3.0, antialiased: true)

                    HUIStateButton("SELECT",
                                   .channelStrip(channel, .select),
                                   .yellow)

                    FaderView(channel: channel)
                }
            }
        }
        
    }

    struct FaderView: View {
        
        @EnvironmentObject var huiSurface: MIDI.HUI.Surface

        static let faderHeight: CGFloat = 200
        static let faderWidth: CGFloat = 5
        static let faderCapsuleHeight: CGFloat = 40
        static let faderCapsuleWidth: CGFloat = 25

        let channel: Int

        @State private var isPressed = false

        var body: some View {
            let pos = CGFloat(huiSurface.state.channelStrips[channel].fader.levelUnitInterval)

            ZStack {
                Rectangle()
                    .frame(width: Self.faderWidth, height: Self.faderHeight, alignment: .center)
                    .background(Color.black)

                VStack(alignment: .center, spacing: 0) {
                    Spacer(minLength: 0)
                    Rectangle()
                        .frame(width: Self.faderCapsuleWidth, height: Self.faderCapsuleHeight, alignment: .center)
                        .background(Color.gray)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    if !isPressed {
                                        pressedAction()
                                        isPressed = true
                                        return
                                    }
                                    #warning("> finish this")
                                }
                                .onEnded { _ in
                                    releasedAction()
                                    isPressed = false
                                }
                        )
                    Spacer()
                        .frame(height: pos * (Self.faderHeight - Self.faderCapsuleHeight))
                }
                .frame(height: Self.faderHeight, alignment: .center)
            }
        }

        private func pressedAction() {
            huiSurface.transmitSwitch(.channelStrip(channel, .faderTouched), state: true)
        }

        private func releasedAction() {
            huiSurface.transmitSwitch(.channelStrip(channel, .faderTouched), state: false)
        }
        
    }
    
}
