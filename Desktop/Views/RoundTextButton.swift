//
//  RoundTextButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct RoundTextButton: View {
    typealias Callback = () -> ()
    
    var icon: Image
    var title: String
    var subtitle: String
    var selected: Bool
    var callback: Callback
    var style = ButtonStyle()
    
    init(icon: Image,
         title: String,
         subtitle: String,
         selected: Bool,
         callback: @autoclosure @escaping Callback,
         style: ButtonStyle = ButtonStyle()) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.selected = selected
        self.callback = callback
        self.style = style
    }
    
    var body: some View {
        VStack {
            RoundButton(icon: icon, selected: selected, callback: callback(), style: style)
                .frame(width: UIStyle.normal.roundButtonSize, height: UIStyle.normal.roundButtonSize)
            Text(title)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Color.white)
            Text(subtitle)
                .font(.caption)
                .foregroundColor(Color.white)
        }
    }
}
