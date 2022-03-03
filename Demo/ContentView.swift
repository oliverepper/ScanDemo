//
//  ContentView.swift
//  Demo
//
//  Created by Oliver Epper on 03.03.22.
//

import SwiftUI
import OSLog

struct ContentView: View {
    @Environment(\.bluetoothManager) var manager

    var body: some View {
        Text("Demo")
            .padding()
            .task {
                for await state in manager.state() {
                    if state == .poweredOn { break }
                }
                os_log("Bluetooth ready")
                for await scanData in manager.scanForPeripherals() {
                    print(scanData)
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
