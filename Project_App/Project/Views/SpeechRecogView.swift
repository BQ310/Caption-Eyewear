//
//  SpeechRecogView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/10/23.
//

import SwiftUI

struct SpeechRecogView: View {
    @ObservedObject var blueTooth: BLEController
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var sendData = false
    @State var userText: String = ""
    @State var startIndex = 0
    var body: some View {
        VStack {
            ScrollView{
                Text(speechRecognizer.transcript)
            }
            
            
            // Record Button Setup
            RecordButtonView
            
            Spacer()
            
            //Text Editior View
            TextEditorView
            
            // Button to send Data
            SendButtonView
            Spacer()
        }
        .onChange(of: speechRecognizer.transcript, perform: { newValue in
            if (isRecording) {
                // Need Convert string to Array
                let arrayString = Array(newValue)
                
                print(newValue)
                if startIndex >= arrayString.count {
                    startIndex = arrayString.count-1
                }
                let newString = String(arrayString[startIndex...])
                startIndex = arrayString.count
                
                let nsString = newString as NSString
                guard let sendData = nsString.data(using: String.Encoding.utf8.rawValue) else {
                    print("Can't Convert String to Data")
                    return
                }
                
                // Writing TO Characteristic
                if let characteristic = blueTooth.importantChar, let peripheral = blueTooth.connectedPeripheral {
                    peripheral.writeValue(sendData,
                                          for: characteristic,
                                          type: .withResponse)
                    
                }
                
            }
        })
        .onAppear{
            speechRecognizer.resetTranscript()
        }
    }
    
    private var SendButtonView: some View {
        // Button to send Data
        Button(action: {
            // Converting String to DATA
            let nsString = userText as NSString
            guard let sendData = nsString.data(using: String.Encoding.utf8.rawValue) else {
                print("Can't Convert String to Data")
                return
            }
            print("Sending Data: \(sendData)")
            
            // Writing TO Characteristic
            if let characteristic = blueTooth.importantChar, let peripheral = blueTooth.connectedPeripheral {
                peripheral.writeValue(sendData,
                                      for: characteristic,
                                      type: .withResponse)
                
            }
        }) {
            Text("Send")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(isRecording || userText.isEmpty ? Color.blue.opacity(0.5) : Color.blue)
                .cornerRadius(10)
        }
        .disabled(isRecording || userText.isEmpty)
    }
    
    private var RecordButtonView: some View {
        Button(action: {
            if !isRecording {
                speechRecognizer.startTranscribing()
            } else {
                startIndex = 0
                speechRecognizer.stopTranscribing()
            }
            isRecording.toggle()
        }) {
            Text(isRecording ? "Stop" : "Record")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(isRecording ? Color.red : Color.blue)
                .cornerRadius(10)
        }
    }
    
    private var TextEditorView: some View {
        // User Text Input
        TextEditor(text: $userText)
            .frame(width: 200, height: 200)
            .scrollContentBackground(.hidden)
            .foregroundColor(.black)
            .background(RoundedRectangle(cornerRadius: 25)
                .fill(.white))
            .disabled(isRecording)
    }
}

struct SpeechRecogView_Previews: PreviewProvider {
    static var previews: some View {
        SpeechRecogView(blueTooth: BLEController())
            .preferredColorScheme(.dark)
    }
}
