//
//  ContentView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct ContentView: View {
    @State private var showSecondScreen: Bool = false
    @StateObject var bluetooth = BLEController()
    let backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    init() {
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.init(.black)]

    }
    var body: some View {
        
        NavigationView {
            ZStack {
                Rectangle()
                    .fill(Color(backgroundColor))
                    .ignoresSafeArea()
                
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
                    
                    NavigationLink(destination: SecondView(blueTooth: bluetooth)) {
                        MainButtonView(name_button: "Start")
                    }
                    Spacer()
                }
            }
        }.navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
            ContentView()
    }
}
