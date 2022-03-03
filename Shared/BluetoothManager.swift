//
//  BluetoothManager.swift
//  Schreibtisch
//
//  Created by Oliver Epper on 24.02.22.
//

import Foundation
import CoreBluetooth


public final class BluetoothManager: NSObject {
    typealias DiscoverData = (CBPeripheral, [String: Any], NSNumber)

    private var manager: CBCentralManager?

    private var stateContinuation: AsyncStream<CBManagerState>.Continuation?
    private var discoveredPeripheralsContinuation: AsyncStream<DiscoverData>.Continuation?
    private var connectPeripheralContinuation: CheckedContinuation<PeripheralController, Error>?

    var state: CBManagerState {
        manager?.state ?? .unknown
    }

    func states() -> AsyncStream<CBManagerState> {
        return AsyncStream<CBManagerState> {
            stateContinuation = $0
            manager = CBCentralManager(delegate: self, queue: nil)
        }
    }

    func scanForPeripherals() -> AsyncStream<DiscoverData> {
        if manager?.state == .poweredOn { manager?.scanForPeripherals(withServices: nil, options: nil) }
        return AsyncStream<DiscoverData> { discoveredPeripheralsContinuation = $0 }
    }

    func scanForPeripheral(named name: String) async -> CBPeripheral {
        for await (peripheral, _, _) in scanForPeripherals() {
            if peripheral.name == name {
                manager?.stopScan()
                return peripheral
            }
        }
        fatalError()
    }

    func stop() {
        manager?.stopScan()
    }

    func connect(peripheral: CBPeripheral) async throws -> PeripheralController {
        manager?.connect(peripheral, options: nil)
        return try await withCheckedThrowingContinuation { connectPeripheralContinuation = $0 }
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        stateContinuation?.yield(central.state)
    }

    public func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print(".", terminator: "")
        discoveredPeripheralsContinuation?.yield((peripheral, advertisementData, RSSI))
    }

    public func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            connectPeripheralContinuation?.resume(throwing: error)
        }
        fatalError("didFailToConnect called without error")
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectPeripheralContinuation?.resume(with: .success(PeripheralController(peripheral: peripheral)))
    }
}

