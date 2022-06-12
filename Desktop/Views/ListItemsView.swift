//
//  ListItemsView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct ListItemsView<Item: ListItem>: View {
    enum Mode {
        case loading
        case error
        case normal
    }
    var icon: Image
    var title: String
    var footer: String
    var items: [Item]
    var mode: Mode
    
    var delimeter: some View {
        Rectangle()
            .fill(Color.white)
            .frame(height: 1)
            .opacity(0.2)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
                Text(title)
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
            }.padding()
            delimeter
            if mode == .normal {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(items, id: \.id) { item in
                            ListItemView(title: item.title, subtitle: item.subtitle)
                        }
                    }
                }
            } else if mode == .error {
                Spacer()
                Text("Your request produced an error.\nPlease try later.")
                    .font(.caption)
                    .lineLimit(2)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                Spacer()
            } else if mode == .loading {
                Spacer()
                ProgressView()
                Spacer()
            }
            delimeter
            VStack {
                Text(footer)
                    .font(.callout)
                    .foregroundColor(Color.white)
                    .fontWeight(.semibold)
            }.padding()
        }
    }
}

fileprivate struct ListItemView: View {
    var title: String
    var subtitle: String
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .fontWeight(.bold)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Color.white)
                    .fontWeight(.medium)
            }.padding(.vertical, 10)
            .padding(.horizontal, 15)
            Rectangle()
                .fill(Color.white)
                .frame(height: 1)
                .opacity(0.2)
        }
    }
}
