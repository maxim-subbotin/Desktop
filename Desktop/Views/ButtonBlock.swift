//
//  ButtonBlock.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct ButtonBlock: View {
    struct SubButton {
        enum ImageName {
            case system(name: String)
            case custom(name: String)
            
            var image: Image {
                switch self {
                case .system(let name):
                    return Image(systemName: name)
                case .custom(let name):
                    return Image(name).renderingMode(.template)
                }
            }
        }
        var imageName: ImageName
        var selected: Bool
        var callback: (() -> ())
        var style: ButtonStyle
        
        init(imageName: ImageName, selected: Bool, callback: @autoclosure @escaping () -> (), style: ButtonStyle = .init()) {
            self.imageName = imageName
            self.selected = selected
            self.callback = callback
            self.style = style
        }
    }
    var buttons = [SubButton]()
    private var buttonSize: CGFloat = UIStyle.normal.roundButtonSize
    
    init(buttons: [SubButton]) {
        self.buttons = buttons
    }
    
    var body: some View {
        VStack(spacing: UIStyle.normal.panelSpacing) {
            if buttons.count != 4 {
                //
            } else {
                HStack(spacing: UIStyle.normal.panelSpacing) {
                    RoundButton(icon: buttons[0].imageName.image, selected: buttons[0].selected, callback: buttons[0].callback(), style: buttons[0].style)
                        .modifier(RoundBlockButton(size: buttonSize))
                    RoundButton(icon: buttons[1].imageName.image, selected: buttons[1].selected, callback: buttons[1].callback(), style: buttons[1].style)
                        .modifier(RoundBlockButton(size: buttonSize))
                }
                HStack(spacing: UIStyle.normal.panelSpacing) {
                    RoundButton(icon: buttons[2].imageName.image, selected: buttons[2].selected, callback: buttons[2].callback(), style: buttons[2].style)
                        .modifier(RoundBlockButton(size: buttonSize))
                    RoundButton(icon: buttons[3].imageName.image, selected: buttons[3].selected, callback: buttons[3].callback(), style: buttons[3].style)
                        .modifier(RoundBlockButton(size: buttonSize))
                }
            }
        }
        .padding(UIStyle.normal.panelSpacing)
    }
}
