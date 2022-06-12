//
//  RoundLabeledButton.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct RoundLabeledButton: View {
    var title: String
    var selected: Bool
    var callback: () -> ()
    
    init(title: String, selected: Bool, callback: @autoclosure @escaping () -> ()){
        self.title = title
        self.selected = selected
        self.callback = callback
    }
    
    var body: some View {
        GeometryReader { geom in
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.black)
                    .opacity(0.5)
                HStack {
                    RoundButton(icon: Image(systemName: "moon.fill"), selected: selected, callback: callback())
                        .modifier(RoundBlockButton(size: geom.size.height > 15 ? geom.size.height - 15 : 1))
                        .padding(.horizontal, 10)
                    Text(title)
                        .foregroundColor(Color.white)
                        .font(.callout)
                    Spacer()
                }
            }
        }
    }
}
