//
//  SecondView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct SecondView: View {
    @ObservedObject var blueTooth: BLEController
    let backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color(backgroundColor))
                .ignoresSafeArea()
            
            // Goes to another view or opens up device
            
            VStack {
                NavigationLink(destination: BlueToothPeripView(blueTooth: blueTooth)) {
                    BlueToothView()
                }
                
                NavigationLink(destination: SpeechRecogView(blueTooth: blueTooth)) {
                    MainButtonView(name_button: "Continue")
                }
            }
            .navigationTitle("Connecting Glasses")
            .navigationBarTitleDisplayMode(.large)
            
        }

    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SecondView(blueTooth: BLEController())
        }
    }
}
