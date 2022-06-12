//
//  SingleButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct SingleButton: View {
    typealias Callback = () -> ()
    struct Style {
        var deselectButtonColor: Color = .black
        var selectButtonColor: Color = .white
        var deselectIconColor: Color = .white
        var selectIconColor: Color = .blue
    }
    
    var iconName: String
    var selected: Bool
    var callback: Callback?
    var style: Style = Style()
    
    init(iconName: String, selected: Bool, callback: @autoclosure @escaping Callback, style: Style = Style()) {
        self.iconName = iconName
        self.selected = selected
        self.callback = callback
        self.style = style
    }
    
    var body: some View {
        GeometryReader { geom in
            Button(action: {
                callback?()
            }, label: {
                ZStack {
                    RoundedRectangle(cornerRadius: geom.size.width > 30 ? UIStyle.normal.singleButtonIconPadding : geom.size.width / 2)
                        .fill(selected ? style.selectButtonColor : style.deselectButtonColor)
                        .opacity(0.5)
                    Image(systemName: iconName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(selected ? style.selectIconColor : style.deselectIconColor)
                        .padding(geom.size.width > 40 ? UIStyle.normal.singleButtonIconPadding : 0)
                }
            })
        }
    }
}
