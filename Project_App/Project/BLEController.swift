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
    var peripherals: [CBPeripheral] = [] // List of peripherals found
    var connectedPeripheral: CBPeripheral? // nil
    var importantChar: CBCharacteristic?
    var mainService: CBService?
    
    var scanning: Bool = false // Scanning For Peripherals
    let serviceUUID: CBUUID = CBUUID(string: "fd4733c0-def3-11ed-b5ea-0242ac120002") // Glasses Service UUID
    let serviceCHARUUID: CBUUID = CBUUID(string: "fd4733c1-def3-11ed-b5ea-0242ac120002") // Glasses Service char UUID
    @Published var peripheralConnected: Bool = false; //  IS peripheral connected VIEW UI changed
    @Published var peripheralNames: [String] = [] // Peripheral Names VIEW UI changed
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("BLE ON: Ready to scan for peripherals")
        }
    }
    
    func startScanningPeripherals() {
        if !self.scanning {
            self.scanning = true
            print("Scanning For Peripherals")
            self.myCentral.scanForPeripherals(withServices: [serviceUUID])
        }
    }
    
    func stopScanningPeripherals() {
        if self.scanning {
            self.scanning = false
            print("Stopped Scanning for Peripherals")
            self.myCentral.stopScan()
        }
    }
    
    // FOUND PERIPHERALS
    /*If a periperal is found saved its name and appends it to self.peripheral*/
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralNames.append(peripheral.name ?? "unnamed")
        }
    }
    
    // PERIPHERAL CONNECTED
    /* function handles the connected peripheral*/
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Peripheral Connected")
        self.stopScanningPeripherals()
        self.connectedPeripheral = peripheral
        self.peripheralConnected = true
        
        // Discovering Characteristics
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    
    // PERIPHERAL DISCONNECTED
    /*Resets all values if peripheral is disconnected*/
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
        // Checking For error
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("Error is nil")
        }
        
        /*Resetting fields*/
        self.peripheralConnected = false
        self.connectedPeripheral = nil
        self.peripherals = []
        self.peripheralNames = []
        
    }
    
    
    /*==================================Peripheral Delegate====================================*/
    
    // DISCOVERED PERIPHERAL SERIVCES
    /*Discovering the services for peripheral*/
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.mainService = peripheral.services?.first
        print("Discovered Peripheral Services")
        if let services = peripheral.services {
            print(services)
            if !services.isEmpty {
                print("Discovering Characteristics of Services")
                for service in services {
                    peripheral.discoverCharacteristics([serviceCHARUUID], for: service)
                }
            }
        }
    }
    
    // DISCOVERED PERIPHERAL SERVICE CHARACTERISTICS
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        print("Found Characteristic")
        self.importantChar = service.characteristics?.first
    }
    
    // WRITING VALUE TO CHARACTERISTIC CHECK
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
    }
    
    
    
    
}
