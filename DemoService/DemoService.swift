//
//  DemoService.m
//  DemoService
//
//  Created by Oliver Epper on 03.03.22.
//

import CoreBluetooth
import OSLog

final class DemoService: DemoServiceProtocol {
    private let manager = BluetoothManager()

    func connect(withReply reply: @escaping () -> Void) {
        Task {
            do {
                try await scan()
            } catch {
                print(error)
            }
        }
        reply()
    }

    private func scan() async throws {
        if manager.state != .poweredOn {
            for await state in manager.states() {
                if state == .poweredOn { break }
            }
            os_log("Bluetooth ready")
        } else {
            os_log("Bluetooth was ready")
        }

        for await scanData in manager.scanForPeripherals() {
            print(scanData)
        }
    }
}
