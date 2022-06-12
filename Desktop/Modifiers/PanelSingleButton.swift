//
//  PanelSingleButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct PanelSingleButton: ViewModifier {
    var size: CGFloat
    
    func body(content: Content) -> some View {
        content
            .frame(width: size, height: size)
    }
}
