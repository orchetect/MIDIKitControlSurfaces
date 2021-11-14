//
//  Labels.swift
//  HUISurface
//  MIDIKitControlSurfaces • https://github.com/orchetect/MIDIKitControlSurfaces
//

import SwiftUI

func HUISectionLabel(_ label: String) -> Text {
    
    Text(label)
        .font(.system(size: 10))
        
}

struct HUISectionDivider: View {
    
    enum Orientation {
        case vertical
        case horizontal
    }
    
    var orientation: Orientation
    
    init(_ orientation: Orientation) {
        self.orientation = orientation
    }
    
    var body: some View {
        
        switch orientation {
        case .vertical:
            Color.primary.frame(width: 1)
            
        case .horizontal:
            Color.primary.frame(height: 1)
            
        }
        
    }
    
}
