//
//  ContentView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showSecondScreen: Bool = false
    var body: some View {
        
        NavigationView {
            ZStack {
                Color("ThemeColor")
                    .ignoresSafeArea(.all)
                
                VStack {
                    Image(systemName: "eyeglasses")
                        .foregroundColor(.white)
                        .font(.system(size: 120))
                        .padding(50)
                    
                    Text("Caption Glass")
                        .fontWeight(.bold)
                        .font(.system(size: 80))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    NavigationLink(destination: SecondView()) {
                        MainButtonView(name_button: "Start")
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
