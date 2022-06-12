//
//  ContentView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DesktopView()
            .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
