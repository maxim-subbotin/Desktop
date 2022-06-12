//
//  NetworkRoundTextButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct NetworkRoundTextButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: UIStyle.normal.expandBlockButtonSize)
    }
}
