//
//  ContentView.swift
//  Demo
//
//  Created by Oliver Epper on 03.03.22.
//

import SwiftUI
import OSLog
import DemoService

final class ViewModel: ObservableObject {
    private let connection: NSXPCConnection

    init() {
        connection = NSXPCConnection(serviceName: "de.oliver-epper.DemoService")
        connection.remoteObjectInterface = NSXPCInterface(with: DemoServiceProtocol.self)
        connection.resume()
    }

    func connect() {
        let service = connection.remoteObjectProxyWithErrorHandler { error in
            print(error)
        } as? DemoServiceProtocol

        service?.connect() {
            print("Connected to XPC Service")
        }
    }
}

struct ContentView: View {
    @Environment(\.bluetoothManager) var manager
    @StateObject var model = ViewModel()

    var body: some View {
        VStack {
            Button("Start scanning") {
                Task {
                    await scan()
                }
            }
            Button("Stop scanning") {
                manager.stop()
            }
            Button("Start scanning via XPC Service") {
                model.connect()
            }
        }
        .padding()
        .task {
            await scan()
        }
    }

    func scan() async {
        if manager.state != .poweredOn {
            for await state in manager.states() {
                if state == .poweredOn { break }
            }
            os_log("Bluetooth ready")
        } else {
            os_log("Bluetooth was ready")
        }

        for await _ in manager.scanForPeripherals() {
            print("|", terminator: "")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
