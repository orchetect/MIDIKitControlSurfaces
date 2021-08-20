//
//  ContentView.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import MIDIKitControlSurfaces
import SwiftUI

struct ContentView: View {
    private let midiManager = MIDI.IO.Manager(
        clientName: "HUISurface",
        model: "HUISurface",
        manufacturer: "Orchetect",
        notificationHandler: nil
    )

    @ObservedObject private var huiSurface: MIDI.HUI.Surface

    init() {
        // set up HUI Surface object

        huiSurface = MIDI.HUI.Surface()

        huiSurface.huiEventHandler = { _ in
            // Logger.debug(surfaceEvent)
        }

        huiSurface.midiOutHandler = { [weak midiManager] midiEvents in
            try? midiManager?
                .managedOutputs["MIDIKit HUI Output"]?
                .send(events: midiEvents)
        }

        // set up MIDI ports

        do {
            try midiManager.start()

            try midiManager.addInput(
                name: "MIDIKit HUI Input",
                tag: "MIDIKit HUI Input",
                uniqueID: .userDefaultsManaged(key: "MIDIKit HUI Input"),
                receiveHandler: .events { [weak huiSurface] midiEvents in
                    // since handler callbacks from MIDI are on a CoreMIDI thread, parse the MIDI on the main thread because SwiftUI state in this app will be updated as a result
                    DispatchQueue.main.async {
                        huiSurface?.midiIn(events: midiEvents)
                    }
                }
            )

            try midiManager.addOutput(
                name: "MIDIKit HUI Output",
                tag: "MIDIKit HUI Output",
                uniqueID: .userDefaultsManaged(key: "MIDIKit HUI Output")
            )
        } catch {
            // Logger.error("Error setting up MIDI.")
        }
    }

    var body: some View {
        HUISurfaceView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(huiSurface)
    }
}

#if DEBUG
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
#endif
