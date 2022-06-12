//
//  RoundButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct ButtonStyle {
    var deselectButtonColor: Color = .white
    var selectButtonColor: Color = .blue
    var deselectIconColor: Color = .white
    var selectIconColor: Color = .white
}

struct RoundButton: View {
    typealias Callback = () -> ()
    var icon: Image
    var selected: Bool
    var callback: Callback
    var style = ButtonStyle()
    
    init(icon: Image,
         selected: Bool,
         callback: @autoclosure @escaping Callback,
         style: ButtonStyle = ButtonStyle()) {
        self.icon = icon
        self.selected = selected
        self.callback = callback
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack {
                Circle()
                    .fill(selected ? style.selectButtonColor : style.deselectButtonColor)
                    .opacity(selected ? 1.0 : 0.25)
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(selected ? style.selectIconColor : style.deselectIconColor)
                    .padding(geom.size.width > 40 ? UIStyle.normal.roundButtonIconPadding : 0)
            }
            .onTapGesture {
                callback()
            }
        }
    }
}
