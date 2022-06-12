//
//  MediaBlock.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct MediaBlock: View {
    var title: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.black)
                .opacity(0.5)
            VStack {
                Text(title)
                    .foregroundColor(Color.white)
                    .font(.callout)
                Spacer()
                HStack {
                    Image(systemName: "eject.fill")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 15, height: 15)
                        .opacity(0.5)
                    Image(systemName: "play.fill")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 20, height: 20)
                        .padding(.horizontal, 15)
                    Image(systemName: "pause.fill")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 15, height: 15)
                        .opacity(0.5)
                }
            }.padding()
        }
    }
}
