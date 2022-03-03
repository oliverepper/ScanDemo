//
//  PeripheralController.swift
//  Schreibtisch
//
//  Created by Oliver Epper on 24.02.22.
//

import Foundation
import CoreBluetooth

final class PeripheralController: NSObject {
    static let offset: UInt16 = 67
    static let positionServiceUUID = CBUUID(string: "99FA0020-338A-1024-8A49-009C0215F78A")
    static let positionCharacteristicUUID = CBUUID(string: "99FA0021-338A-1024-8A49-009C0215F78A")

    private var peripheral: CBPeripheral

    private var positionCharacteristic: CheckedContinuation<CBCharacteristic, Error>?
    private var positionsContinuation: AsyncStream<Int>.Continuation?

    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()

        self.peripheral.delegate = self
        self.peripheral.discoverServices([Self.positionServiceUUID])
    }

    private func positionCharacteristic() async throws -> CBCharacteristic {
        return try await withCheckedThrowingContinuation { positionCharacteristic = $0 }
    }

    func positions() async throws -> AsyncStream<Int> {
        let characteristic = try await positionCharacteristic()
        peripheral.setNotifyValue(true, for: characteristic)
        peripheral.readValue(for: characteristic)
        return AsyncStream<Int> { positionsContinuation = $0 }
    }
}

extension PeripheralController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print(error)
        }

        peripheral.services?.forEach { service in
            peripheral.discoverCharacteristics([Self.positionCharacteristicUUID], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            positionCharacteristic?.resume(with: .failure(error))
        }

        if let characteristic = service.characteristics?.first {
            positionCharacteristic?.resume(with: .success(characteristic))
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print(error)
        }
        if let value = characteristic.value {
            let position = [value[0], value[1]].withUnsafeBytes { $0.load(as: UInt16.self) }
            positionsContinuation?.yield(Int(position/100 + Self.offset))
        }
    }
}
