//
//  ControlStore.swift
//  Desktop
//
//  Created by Maxim Subbotin on 11.06.2022.
//

import Foundation
import SwiftUI
import AVKit
import Combine

enum ControlAction {
    case toggleTorch
    case toggleLock
    case toggleScreenShare
    case toggleReminder
    case togglePhone
    case toggleCamera
    case setBrightness(_ val: CGFloat)
    case setVolume(_ val: CGFloat)
    case toggleFocus
    case toggleFlight
    case toggleWifi
    case toggleCellular
    case toggleBluetooth
    case toggleAirdrop
    case toggleHotspot
    case getWifiInfo
    case getBluetoothDevices
}

protocol ControlViewModel: ObservableObject {
    var flightMode: Bool { get }
    var wifi: Bool { get }
    var cellular: Bool { get }
    var bluetooth: Bool { get }
    var airdrop: Bool { get }
    var hotspot: Bool { get }
    var trackTitle: String { get }
    var locked: Bool { get }
    var screenShare: Bool { get }
    var focus: Bool { get }
    var brightness: CGFloat { get }
    var volume: CGFloat { get }
    var torch: Bool { get }
    var reminder: Bool { get }
    var phone: Bool { get }
    var camera: Bool { get }
    var ssid: String { get }
    
    var loadingDevicesProcess: Bool { get }
    var devices: [BluetoothDevice] { get }
    var bluetoothError: Error? { get }
    
    func dispatch(_ action: ControlAction)
}

class TestControlViewModel: ControlViewModel {
    @Published private(set) var flightMode: Bool = false
    @Published private(set) var wifi: Bool = true
    @Published private(set) var cellular: Bool = true
    @Published private(set) var bluetooth: Bool = false
    @Published private(set) var airdrop: Bool = false
    @Published private(set) var hotspot: Bool = false
    @Published private(set) var trackTitle: String = "Not playing"
    @Published private(set) var locked: Bool = false
    @Published private(set) var screenShare: Bool = false
    @Published private(set) var focus: Bool = false
    @Published private(set) var brightness: CGFloat = UIScreen.main.brightness
    @Published private(set) var volume: CGFloat = CGFloat(AVAudioSession.sharedInstance().outputVolume)
    @Published private(set) var torch: Bool = false
    @Published private(set) var reminder: Bool = false
    @Published private(set) var phone: Bool = false
    @Published private(set) var camera: Bool = false
    @Published private(set) var ssid: String = ""
    @Published private(set) var devices: [BluetoothDevice] = []
    @Published private(set) var loadingDevicesProcess: Bool = false
    @Published private(set) var bluetoothError: Error? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func dispatch(_ action: ControlAction) {
        switch action {
        case .toggleTorch:
            self.torch.toggle()
            _ = TorchProvider().turnTorch(on: self.torch)
        case .toggleLock:
            self.locked.toggle()
        case .toggleScreenShare:
            self.screenShare.toggle()
        case .toggleReminder:
            self.reminder.toggle()
        case .togglePhone:
            self.phone.toggle()
        case .toggleCamera:
            self.camera.toggle()
        case .setBrightness(let v):
            self.brightness = v
            UIScreen.main.brightness = v
        case .setVolume(let v):
            self.volume = v
        case .toggleFocus:
            self.focus.toggle()
        case .toggleFlight:
            self.flightMode.toggle()
        case .toggleWifi:
            self.wifi.toggle()
        case .toggleCellular:
            self.cellular.toggle()
        case .toggleBluetooth:
            self.bluetooth.toggle()
        case .toggleAirdrop:
            self.airdrop.toggle()
        case .toggleHotspot:
            self.hotspot.toggle()
        case .getWifiInfo:
            loadWifiInfo()
        case .getBluetoothDevices:
            loadBluetoothDevices()
        }
    }
}

extension TestControlViewModel {
    func loadWifiInfo() {
        Future<String, Error> { promise in
            WifiProvider().getWifiInfo(callback: { res in
                switch res {
                case .success(let ssid):
                    promise(.success(ssid))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(_):
                    self.ssid = "Unavailable"
                case .finished:
                    print("Current network: \(self.ssid)")
                }
            }, receiveValue: { ssid in
                self.ssid = ssid
            }).store(in: &cancellables)
    }
    
    func loadBluetoothDevices() {
        self.devices.removeAll()
        self.loadingDevicesProcess = true
        self.bluetoothError = nil
        Future<[BluetoothDevice], Error> { promise in
            BluetoothProvider().getBTDevices(callback: { res in
                switch res {
                case .success(let devices):
                    promise(.success(devices))
                case .failure(let error):
                    promise(.failure(error))
                }
            })
        }.eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { error in
                switch error {
                case .failure(let error):
                    self.devices = []
                    self.bluetoothError = error
                case .finished:
                    print("Bluetooth devices have been scanned: \(self.devices.count)")
                }
                self.loadingDevicesProcess = false
            }, receiveValue: { devices in
                self.devices = devices
            }).store(in: &cancellables)
    }
}
