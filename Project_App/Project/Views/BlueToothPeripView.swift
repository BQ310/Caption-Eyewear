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
    
    init(blueTooth: BLEController) {
        self.blueTooth = blueTooth
    }
    let backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    var body: some View {
            ZStack {
                VStack(alignment: .leading) {
                    if (blueTooth.scanning) {
                        HStack {
                            Text("Scanning ")
                            ProgressView()
                        }.padding(.leading)
                    }
                    List(blueTooth.peripherals) { peripheral in
                        
                        Button(action: {
                            blueTooth.myCentral.connect(peripheral.peripheral)
                            dismiss()
                        }) {
                            Text(peripheral.name)
                                .foregroundColor(.red)
                                .font(.headline)
                                .background(.blue)
                        }
                    }
                    .navigationTitle("BlueTooth Devices")
                }
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
        NavigationView {
            BlueToothPeripView(blueTooth: BLEController())
        }
    }
}
