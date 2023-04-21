//
//  BlueToothPeripView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/8/23.
//

import SwiftUI
import CoreBluetooth
struct BlueToothPeripView: View {
    @ObservedObject var blueTooth: BLEController
    @Environment (\.dismiss) var dismiss
    var body: some View {
        VStack {
            List(blueTooth.peripherals, id: \.self) { peripheral in
                
                Button(action: {
                    blueTooth.myCentral.connect(peripheral)
                    dismiss()
                }) {
                    Text(peripheral.name ?? "unnamed")
                        .foregroundColor(.red)
                        .font(.headline)
                        .background(.blue)
                }
            }
            .navigationTitle("BlueTooth Devices")
        }
        
        .toolbar {
            Button("Scan") {
                blueTooth.startScanningPeripherals()
            }
        }
        
    }
}

struct BlueToothPeripView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            BlueToothPeripView(blueTooth: BLEController())
        }
    }
}
