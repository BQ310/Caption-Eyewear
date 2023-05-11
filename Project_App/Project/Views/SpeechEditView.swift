//
//  SpeechEditView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/30/23.
//

import SwiftUI

struct SpeechEditView: View {
    @Binding var textInput: Bool
    @Binding var textPlacement: Bool
    @Binding var soundMeterEnable: Bool
    @Binding var speedSelect: Bool
    var body: some View {
        List {
            
            Section("PreferenceS") {
                // TEXT PLACEMENT
                    LineSelectorView(textPlacment: $textPlacement)
                
                // soundEnableToggle
                    soundMeterEnableView
                
                // text insert
                    textSelectionView
                
                // speed selector
                    speedSelectorView
            }
            
        }
    }
    
    
    /*VIEWS*/
    var soundMeterEnableView: some View {
        Toggle(isOn: $soundMeterEnable, label: {
            Text("Sound Meter Enable")
        })
    }
    
    var textSelectionView: some View {
        Picker("User Text Input Length", selection: $textInput, content: {
            Text("Single").tag(false)
            Text("Multiple").tag(true)
        })
    }
    
    var speedSelectorView: some View {
        Picker("Text Speed Change", selection: $speedSelect, content: {
            Text("Normal").tag(false)
            Text("Slow").tag(true)
        })
    }
}

struct SpeechEditView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechEditView(textInput: .constant(false), textPlacement: .constant(false), soundMeterEnable: .constant(false),
                       speedSelect: .constant(false))
    }
}
