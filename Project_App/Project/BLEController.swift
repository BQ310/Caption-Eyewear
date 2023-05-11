//
//  BLEController.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import Foundation
import CoreBluetooth

struct BLEPeriphData: Equatable, Hashable, Identifiable{
    let id = UUID()
    let name: String
    let peripheral: CBPeripheral
    init(_name: String, _peripheral: CBPeripheral) {
        name = _name
        peripheral = _peripheral
    }
}

class BLEController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var myCentral: CBCentralManager!
    @Published var peripherals: [BLEPeriphData] = [] // List of peripherals found
    var connectedPeripheral: CBPeripheral? // nil
    var textSpeechChar: CBCharacteristic?
    var textPlacementChar: CBCharacteristic?
    var textSpeed: CBCharacteristic?
    var mainService: CBService?
    
    @Published var scanning: Bool = false // Scanning For Peripherals
    let serviceUUID: CBUUID = CBUUID(string: "fd4733c0-def3-11ed-b5ea-0242ac120002") // Glasses Service UUID
    let textSpeechCHARUUID: CBUUID = CBUUID(string: "fd4733c1-def3-11ed-b5ea-0242ac120002") // Glasses TextSpeech char UUID
    let textPlacementCHARUUID: CBUUID = CBUUID(string: "fd4733c2-def3-11ed-b5ea-0242ac120002") // Text Alignment char
    let speedTextCHARUUID: CBUUID = CBUUID(string: "fd4733c3-def3-11ed-b5ea-0242ac120002") // Text Alignment char
    @Published var peripheralConnected: Bool = false; //  IS peripheral connected VIEW UI changed
    
    override init() {
        super.init()
        myCentral = CBCentralManager(delegate: self, queue: nil)
        print("BLUETOOTH CLASS INIT")
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
        print("Found peripheral")
        print(advertisementData)
        let nameOfDevice = advertisementData["kCBAdvDataLocalName"] as? String ?? "unnamed"
        if (nameOfDevice == "unnamed") {
            return
        }
        let device = BLEPeriphData(_name: nameOfDevice, _peripheral: peripheral)
        if !peripherals.contains(where: {$0 == device}) {
            self.peripherals.append(device)
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
        
    }
    
    
    /*==================================Peripheral Delegate====================================*/
    
    // DISCOVERED PERIPHERAL SERIVCES
    /*Discovering the services for peripheral*/
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        self.mainService = peripheral.services?.first
        print("Discovered Peripheral Services")
        //print(peripheral)
        if let services = peripheral.services {
            print(services)
            if !services.isEmpty {
                print("Discovering Characteristics of Services")
                for service in services {
                    peripheral.discoverCharacteristics([textSpeechCHARUUID, textPlacementCHARUUID, speedTextCHARUUID], for: service)
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
        for char in service.characteristics! {
            if char.uuid == textSpeechCHARUUID {
                textSpeechChar = char
            } else if char.uuid == textPlacementCHARUUID {
                textPlacementChar = char
            } else if char.uuid == textSpeechCHARUUID {
                textSpeed = char
            }
        }
    }
    
    // WRITING VALUE TO CHARACTERISTIC CHECK
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
    }
    
    
    
    
}
