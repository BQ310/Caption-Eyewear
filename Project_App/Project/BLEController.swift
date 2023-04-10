//
//  BLEController.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import Foundation
import CoreBluetooth


class BLEController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var myCentral: CBCentralManager!
    var peripherals: [CBPeripheral] = []
    var scanning: Bool = false
    @Published var peripheralNames: [String] = []
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("BLE ON:  Scan for peripherals")
        }
    }
    
    func startScanningPeripherals() {
        if !self.scanning {
            self.scanning = true
            print("Scanning For Peripherals")
            self.myCentral.scanForPeripherals(withServices: nil)
        }
    }
    
    func stopScanningPeripherals() {
        if self.scanning {
            self.scanning = false
            print("Stop Scanning for Peripherals")
            self.myCentral.stopScan()
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed")
        }
    }
}
