//
//  SecondView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct SecondView: View {
    @ObservedObject var blueTooth = BLEController()
    var body: some View {
        ZStack{
            Color("ThemeColor")
                .ignoresSafeArea(.all)
            
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
            
        }
    }
}

struct SecondView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SecondView()
        }
    }
}
