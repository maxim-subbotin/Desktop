//
//  ListItem.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation

protocol ListItem: Identifiable {
    var title: String { get set }
    var subtitle: String { get set }
}
