//
//  NoiseMeterView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/28/23.
//

import SwiftUI

struct NoiseMeterView: View {
    let soundLevel: Int
    var body: some View {
        VStack{
            Text("dB: \(soundLevel)")
                .font(.title)
                .foregroundColor((soundLevel/6) < 13 ? .green : .yellow)
                .bold()
            HStack {
                ForEach(1..<20, id: \.self) { i in
                    RoundedRectangle(cornerRadius: 10)
                        .fill( i <= (soundLevel/6) ? (soundLevel/6) < 13 ? .green : .yellow : .gray )
                        .frame(height: i == 12 ? 25 : 13)
                }
                .animation(.linear, value: soundLevel)
            }
    }
            .padding()
    }
}

struct NoiseMeterView_Previews: PreviewProvider {
    static var previews: some View {
        NoiseMeterView(soundLevel: 80)
    }
}
