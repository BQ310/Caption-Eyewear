//
//  MainButtonView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/6/23.
//

import SwiftUI

struct MainButtonView: View {
    private var button_name: String
    var body: some View {
        Text("\(button_name)")
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                .stroke(.black, lineWidth: 2)
                .background(Color.white.cornerRadius(20))
            )
    }
    
}

extension MainButtonView {
    init(name_button: String) {
        self.button_name = name_button
    }
}

struct MainButtonView_Previews: PreviewProvider {
    static var previews: some View {
        MainButtonView(name_button: "Hello")
    }
}
