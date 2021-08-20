//
//  MomentaryButton.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI
import MIDIKitControlSurfaces

struct MomentaryButton: View {
    
    @State private var isPressed = false

    let title: String
    let pressedAction: () -> Void
    let releasedAction: () -> Void

    var body: some View {
        ZStack {
            Text(title)
                .padding(2)
                .background(isPressed ? Color.blue : Color.gray)
        }
        .highPriorityGesture(
            // this is a workaround to enable a button which triggers two different actions, one on mouse-down and one on mouse-up
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isPressed {
                        pressedAction()
                    }
                    isPressed = true
                }
                .onEnded { _ in
                    releasedAction()
                    isPressed = false
                }
        )
    }
    
}

struct HUIButton: View {
    
    @EnvironmentObject var huiSurface: MIDI.HUI.Surface

    let title: String
    private let param: MIDI.HUI.Parameter.Wrapper

    init(_ title: String = "",
         _ param: MIDI.HUI.Parameter)
    {
        self.title = title
        self.param = .init(param)
    }

    var body: some View {
        MomentaryButton(title: title) {
            huiSurface.transmitSwitch(param.wrapped, state: true)
        } releasedAction: {
            huiSurface.transmitSwitch(param.wrapped, state: false)
        }
        .font(.system(size: 10))
        .foregroundColor(Color.black)
    }
    
}

struct HUIStateButton: View {
    
    @EnvironmentObject var huiSurface: MIDI.HUI.Surface

    let title: String
    private let param: MIDI.HUI.Parameter.Wrapper
    let ledColor: Color

    init(_ title: String = "",
         _ param: MIDI.HUI.Parameter,
         _ ledColor: HUISwitchColor)
    {
        self.title = title
        self.param = .init(param)
        self.ledColor = ledColor.color
    }

    var body: some View {
        HUIButton(title, param.wrapped)
            .colorMultiply(
                huiSurface.state.state(of: param.wrapped)
                    ? ledColor
                    : Color(white: 1, opacity: 1)
            )
    }
    
}

extension HUIStateButton {
    
    enum HUISwitchColor: Equatable, Hashable {
        case yellow
        case green
        case red

        var color: Color {
            switch self {
            case .yellow: return Color.yellow
            case .green: return Color.green
            case .red: return Color.red
            }
        }
    }
    
}

#if DEBUG
    struct MomentaryButton_Previews: PreviewProvider {
        static var previews: some View {
            MomentaryButton(title: "BUTTON",
                            pressedAction: {},
                            releasedAction: {})
        }
    }
#endif
