//
//  Surface.swift
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import Foundation

extension MIDI.HUI {
    
    /// Object representing a single HUI control surface device.
    public class Surface {
        
        // MARK: - State
        
        public internal(set) var state: State
        {
            willSet {
                if #available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *) {
                    objectWillChange.send()
                }
            }
        }
        
        // MARK: - Parser
        
        internal var parser: Parser
        
        // MARK: - Handlers
        
        public typealias HUIEventHandler = ((Event) -> Void)
        
        /// Parser event handler that triggers when HUI events are received.
        public var huiEventHandler: HUIEventHandler? = nil
        
        /// Called when a HUI MIDI message needs transmitting.
        public var midiOutHandler: MIDIOutHandler? = nil
        
        
        // MARK: - init
        
        public init(
            huiEventHandler: HUIEventHandler? = nil,
            midiOutHandler: MIDIOutHandler? = nil
        ) {
            
            self.huiEventHandler = huiEventHandler
            self.midiOutHandler = midiOutHandler
            
            state = State()
            
            parser = Parser()
            
            parser.huiEventHandler = { [weak self] event in
                // send ping-reply if ping request is received
                if case .pingReceived = event {
                    self?.transmitPing()
                }
                
                // process event
                if let surfaceEvent = self?.state.updateState(receivedEvent: event) {
                    self?.huiEventHandler?(surfaceEvent)
                } else {
                    Logger.debug("Unhandled HUI event: \(event)")
                }
            }
            
            // HUI control surfaces send a System Reset message when they are powered on
            transmitSystemReset()
            
        }
        
        deinit {
            // HUI control surfaces send a System Reset message when they are powered off
            transmitSystemReset()
        }
        
        // MARK: - Methods
        
        /// Resets state back to init state. Handlers are unaffected.
        public func reset() {
            
            state = State()
            parser.reset()
            
        }
        
    }
    
}

extension MIDI.HUI.Surface: ReceivesMIDIEvents {
    
    public func midiIn(event: MIDI.Event) {
        
        parser.midiIn(event: event)
        
    }
    
}

extension MIDI.HUI.Surface: SendsMIDIEvents {
    
}

#if canImport(Combine)
import Combine

@available(macOS 10.15, macCatalyst 13, iOS 13, tvOS 13.0, watchOS 6.0, *)
extension MIDI.HUI.Surface: ObservableObject {
    // nothing here; just add ObservableObject conformance
}
#endif
