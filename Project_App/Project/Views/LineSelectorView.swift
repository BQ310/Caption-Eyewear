//
//  LineSelectorView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/30/23.
//

import SwiftUI


struct LineSelectorView: View {
    @Binding var textPlacment: Bool
    var body: some View {
            Picker("Text Placement", selection: $textPlacment, content: {
                Text("Upper").tag(false)
                Text("Lower").tag(true)
            })
        }
}

struct LineSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        LineSelectorView(textPlacment: .constant(false))
            .preferredColorScheme(.dark)
    }
}
