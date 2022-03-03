//
//  DemoApp.swift
//  Demo
//
//  Created by Oliver Epper on 03.03.22.
//

import SwiftUI

struct BluetoothManagerKey: EnvironmentKey {
    static var defaultValue: BluetoothManager = BluetoothManager()
}

extension EnvironmentValues {
    var bluetoothManager: BluetoothManager {
        get { self[BluetoothManagerKey.self] }
        set { self[BluetoothManagerKey.self] = newValue }
    }
}

@main
struct DemoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
