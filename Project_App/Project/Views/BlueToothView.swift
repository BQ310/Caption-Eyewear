//
//  BlueToothView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct BlueToothView: View {
    var body: some View {
        HStack {
            Image("bluetooth_sym")
            Text("Connect Glasses")
                .fontWeight(.bold)
        }
        .padding()
        .foregroundColor(.black)
        .background(
            RoundedRectangle(cornerRadius: 20)
            .stroke(.black, lineWidth: 2)
            .background(Color.white.cornerRadius(20))
        )
        
    }
}

struct BlueToothView_Previews: PreviewProvider {
    static var previews: some View {
        BlueToothView()
    }
}
