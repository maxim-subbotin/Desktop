//
//  BluetoothListView.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI

struct BluetoothListView<Model: ControlViewModel>: View {
    @StateObject var viewModel: Model
    
    var body: some View {
        ListItemsView(icon: Image("bluetooth"), title: "Bluetooth", footer: "Bluetooth settings", items: viewModel.devices, mode: viewModel.loadingDevicesProcess ? .loading : (viewModel.bluetoothError == nil ? .normal : .error))
            .onAppear() {
                viewModel.dispatch(.getBluetoothDevices)
            }
    }
}
