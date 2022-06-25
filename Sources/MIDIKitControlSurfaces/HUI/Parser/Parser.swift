//
//  Parser.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

@_implementationOnly import SwiftRadix
import Darwin
import MIDIKit

extension MIDI.HUI {
    
    /// HUI MIDI Message Parser
    public class Parser {
        
        // MARK: local state variables
        
        private var timeDisplay: [String] = []
        private var largeDisplay: [String] = []
        private var faderMSB: [MIDI.Byte] = []
        private var switchesZoneSelect: UInt8? = nil
        
        // MARK: handlers
        
        public typealias HUIEventHandler = ((Event) -> Void)
        
        /// Parser event handler that triggers when HUI events are received.
        public var huiEventHandler: HUIEventHandler?
        
        // MARK: - init
        
        public init(
            huiEventHandler: HUIEventHandler? = nil
        ) {
            
            self.huiEventHandler = huiEventHandler
            reset()
            
        }
        
        /// Resets the parser to original init state. (Handlers are unaffected.)
        public func reset() {
            
            timeDisplay = [String](repeating: " ", count: 8)
            
            largeDisplay = [String](repeating: Surface.State.LargeDisplay.defaultStringComponent,
                                    count: 8)
            
            // HUI protocol (and the HUI hardware control surface) has only 8 channel faders.
            // Even though some control surface models have a 9th master fader
            // such as EMAGIC Logic Control and Mackie Control Universal,
            // when running in HUI mode, the master fader is disabled.
            faderMSB = [MIDI.Byte](repeating: 0, count: 8)
            
            switchesZoneSelect = nil
            
        }
        
    }
    
}

// MARK: ReceivesMIDIEvents

extension MIDI.HUI.Parser: ReceivesMIDIEvents {
    
    /// Process HUI MIDI message received from host
    public func midiIn(event: MIDI.Event) {
        
        switch event {
        case .noteOn(let payload) where
            payload.note.number == 0 &&
            payload.velocity.midi1Value == 0:
            
            // handler should send HUI ping-reply to host
            huiEventHandler?(.pingReceived)
            
        case .noteOff(let payload) where
            payload.note.number == 0 &&
            [0, 0x8000].contains(payload.velocity.midi2Value):
            
            // MIDI 2.0 translation from MIDI 1.0 at the Core MIDI subsystem level
            // will force MIDI 1.0 Note On events with a velocity of 0 to be a MIDI 2.0 Note Off event.
            // Technically the MIDI 2.0 spec states that the velocity should be 0,
            // however it seems Core MIDI wants to send a 16-bit midpoint value of 0x8000 instead
            
            // handler should send HUI ping-reply to host
            huiEventHandler?(.pingReceived)
            
        case .sysEx7(let payload):
            guard payload.manufacturer == MIDI.HUI.kMIDI.kSysEx.kManufacturer else { return }
            parse(sysExContent: payload.data)
            
        case .cc:
            parse(controlStatusMessage: event)
            
        case .notePressure:
            parse(levelMetersMessage: event)
            
        default:
            Logger.debug("Unhandled MIDI event received: \(event)")
        }
        
    }
    
}

// MARK: Parser

extension MIDI.HUI.Parser {
    
    private func parse(sysExContent data: [MIDI.Byte]) {
        
        guard data.count >= 2 else { return }
        
        // check for SysEx header
        guard data[0] == MIDI.HUI.kMIDI.kSysEx.kSubID1,
              data[1] == MIDI.HUI.kMIDI.kSysEx.kSubID2
        else { return }
        
        let dataAfterHeader = data
            .suffix(
                from: data.index(data.startIndex,
                                 offsetBy: 2)
            )
        
        guard dataAfterHeader.count > 0 else { return }
        
        switch dataAfterHeader.first {
        case MIDI.HUI.kMIDI.kDisplayType.smallByte:
            // 0x10 channel [4 chars]
            
            guard dataAfterHeader.count == 6 else {
                Logger.debug("Received Small Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            // channel can be 0-8 (0-7 = channel strips, 8 = Select Assign text display)
            let channel = dataAfterHeader[atOffset: 1]
            var newString = ""
            
            for byte in dataAfterHeader[atOffsets: 2...5] {
                newString += MIDI.HUI.kCharTables.smallDisplay[Int(byte)]
            }
            
            if (0...7).contains(channel) {
                huiEventHandler?(.channelName(channelStrip: Int(channel),
                                              text: newString))
            } else if channel == 8 {
                // ***** not storing local state yet - needs to be implemented
                
                // ***** should get folded into a master Select Assign callback
                huiEventHandler?(.selectAssignText(text: newString))
            } else {
                Logger.debug("Small Display text message channel not expected: \(channel). Needs to be coded.")
            }
            
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.largeByte:
            // 0x12 zone [10 chars]
            // it may be possible to receive multiple blocks in the same SysEx message (?), ie:
            // 0x12 zone [10 chars] zone [10 chars]
            // message length test: remove first byte (0x12), then see if remainder is divisible by 11
            
            guard (dataAfterHeader.count - 1) % 11 == 0 else {
                Logger.debug("Received Large Display text MIDI message \(data.hex.stringValue(padTo: 2)) but length was not expected.")
                return
            }
            
            var largeDisplayData = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1]
            
            while largeDisplayData.count >= 11 {
                let zone = Int(largeDisplayData[atOffset: 0])
                
                var newString = ""
                let letters = largeDisplayData[atOffsets: 1...10]
                
                for letter in letters {
                    newString += MIDI.HUI.kCharTables.largeDisplay[Int(letter)]
                }
                largeDisplay[zone] = newString // update local state
                
                largeDisplayData = largeDisplayData.dropFirst(11)
            }
            
            huiEventHandler?(.largeDisplayText(components: largeDisplay))
            return
            
        case MIDI.HUI.kMIDI.kDisplayType.timeDisplayByte:
            guard dataAfterHeader.count > 1 else { return }
            let tcData: [Int] = dataAfterHeader[atOffsets: 1...dataAfterHeader.count-1].map { Int($0) }
            var timeDisplayIndex = 0
            
            for number in tcData {
                var lookupChar = ""
                
                if number < MIDI.HUI.kCharTables.timeDisplay.count {
                    // in lookup table bounds
                    lookupChar = MIDI.HUI.kCharTables.timeDisplay[number]
                } else {
                    // not recognized
                    lookupChar = "?"
                    Logger.debug("Timecode character code not recognized: \(number.hex.stringValue) (Int: \(number))")
                }
                
                // update local state
                timeDisplay[7 - timeDisplayIndex] = lookupChar
                timeDisplayIndex += 1
            }
            
            huiEventHandler?(.timeDisplayText(components: timeDisplay))
            return
            
        default:
            let msg = dataAfterHeader.hex.stringValue(padToEvery: 2)
            
            Logger.debug("Header detected but subsequent message is not recognized: \(msg)")
            
        }
        
    }
    
    private func parse(controlStatusMessage event: MIDI.Event) {
        
        let data = event.midi1RawBytes()
        
        guard data.count >= 3 else { return }
        
        guard data[0] == MIDI.HUI.kMIDI.kControlStatus else { return }
        
        let dataByte1 = data[1]
        let dataByte2 = data[2]
        
        // Control Segment
        
        switch dataByte1 {
        case 0x00...0x07:
            // Channel Strip Fader level MSB
            
            let channel: Int = Int(dataByte1.hex.nibble(0).value)
            
            faderMSB[channel] = dataByte2
            
        case 0x20...0x27:
            // Channel Strip Fader level LSB
            
            let channel: Int = Int(dataByte1.hex.nibble(0).value)
            
            let msb = UInt16(faderMSB[channel]) << 7
            let lsb = UInt16(dataByte2)
            
            guard let level = (msb + lsb).toMIDIUInt14Exactly else { return }
            
            huiEventHandler?(.faderLevel(channelStrip: channel,
                                         level: level))
            
        case 0x10...0x1B:
            // V-Pots
            
            let number: Int = Int(dataByte1 % 0x10)
            let value = dataByte2.toMIDIUInt7
            
            huiEventHandler?(.vPot(number: number,
                                   value: value))
            
        case MIDI.HUI.kMIDI.kControlDataByte1.zoneSelectByte:
            // zone select (1st message)
            
            if let zs = switchesZoneSelect {
                let newZS = dataByte2.hex.stringValue(padTo: 2, prefix: true)
                let oldZS = zs.hex.stringValue(padTo: 2, prefix: true)
                Logger.debug("Received new switch zone select \(newZS), but zone select buffer was not empty. (\(oldZS) was stored)). Storing new zone select.")
            }
            
            switchesZoneSelect = dataByte2
            
        case MIDI.HUI.kMIDI.kControlDataByte1.portOnOffByte:
            // port on, or port off (2nd message)
            
            let port = dataByte2.hex.nibble(0).value.toMIDIUInt4
            var state: Bool
            
            switch dataByte2.hex.nibble(1).value {
            case 0x0:
                state = false
                
            case 0x2:
                // Not sure what this is used for. Any of the HUI docs available don't mention it being used. However, Pro Tools transmits switch messages that utilize this sate nibble. It's been observed being transmit when changing a track's automation mode to Read, and one message per track is sent when opening a Pro Tools session.
                Logger.debug("Received (switch cmd msg 2/2) with unhandled state nibble 0x2. Ignoring.")
                switchesZoneSelect = nil
                return
                
            case 0x4:
                state = true
                
            default:
                let cmd = data.hex.stringValue(padTo: 2, prefix: true)
                let stateNibble = dataByte2.hex.nibble(1).stringValue(prefix: true)
                
                if let zone = switchesZoneSelect {
                    if let guess = MIDI.HUI.Parameter(zone: zone,
                                                      port: port)
                    {
                        Logger.debug("Received \(cmd) (switch cmd msg 2/2) matching \(guess) but has unexpected state nibble \(stateNibble). Ignoring message.")
                    } else {
                        Logger.debug("Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not guess zone and port pair name. Ignoring message.")
                    }
                } else {
                    Logger.debug("Received \(cmd) (switch cmd msg 2/2) but has unexpected state nibble \(stateNibble). Additionally, could not lookup zone and port name because zone select message was not received prior. Ignoring message.")
                }
                
                switchesZoneSelect = nil
                return
                
            }
            
            if let zone = switchesZoneSelect {
                switchesZoneSelect = nil // reset zone select
                huiEventHandler?(.switch(zone: zone, port: port, state: state))
            } else {
                let cmd = data.hex.stringValue(padTo: 2, prefix: true)
                
                Logger.debug("Received message 2 of a switch command (\(cmd) port: \(port), state: \(state)) without first receiving a zone select message. Ignoring.")
                
                switchesZoneSelect = nil
            }
            
        default:
            let b1 = dataByte1.hex.stringValue(padTo: 2, prefix: true)
            let msg = data.hex.stringValue(padTo: 2, prefix: true)
            
            Logger.debug("Unrecognized HUI MIDI status 0xB0 data byte 1: \(b1) in message: \(msg).")
        }
        
    }
    
    private func parse(levelMetersMessage event: MIDI.Event) {
        
        let data = event.midi1RawBytes()
        
        guard data.count >= 3 else { return }
        
        guard data[0] == MIDI.HUI.kMIDI.kLevelMetersStatus else { return }
        
        let dataByte1 = data[1]
        let dataByte2 = data[2]
        
        let channel = Int(dataByte1)
        let sideAndValue = dataByte2 // encodes both side and value
        
        var side: MIDI.HUI.Surface.State.StereoLevelMeter.Side
        var level: Int
        
        if sideAndValue >= 0x10 {
            side = .right // right
            level = Int(sideAndValue % 0x10)
        } else {
            side = .left // left
            level = Int(sideAndValue)
        }
        
        huiEventHandler?(.levelMeters(channelStrip: channel,
                                      side: side,
                                      level: level))
        
    }
    
}
