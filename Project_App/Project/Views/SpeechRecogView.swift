//
//  SpeechRecogView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 4/10/23.
//

import SwiftUI

func stringDifferenceArray(newtranscript: Array<String>, oldTranscript: Array<String>) -> String {
    var newArray = Array<String>()
    //var cont = false
    guard newtranscript.count != 0 else {
        return ""
    }
    // If new transcript bigger than old
    if newtranscript.count > oldTranscript.count {
        for i in 0..<newtranscript.count {
//            if oldTranscript.count != 0 && i < oldTranscript.count && !cont{
//                if newtranscript[i] != oldTranscript[i] {
//                    cont = true
//                    newArray.append(newtranscript[i])
//                }
//            } else {
//                newArray.append(newtranscript[i])
//            }
            if i >= oldTranscript.count {
                newArray.append(newtranscript[i])
            }
        }
    } else {
//        for i in 0..<newtranscript.count {
//            if !cont {
//                if newtranscript[i] != oldTranscript[i] {
//                    cont = true
//                    newArray.append(newtranscript[i])
//                }
//            } else {
//                newArray.append(newtranscript[i])
//            }
//        }
        return ""
    }
    // If new transcript bigger than old
    let r = newArray.joined(separator: " ")
    return r
}


extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

struct SpeechRecogView: View {
    let maxCharScreen = 63
    @ObservedObject var blueTooth: BLEController
    @State var prevTranscript = ""
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @State private var sendData = false
    @State var userText: String = ""
    @State var textPlacement: Bool = false
    @State var showPreference: Bool = false
    @State var soundMeterEnable: Bool = false
    @State var editorChooser: Bool = true
    @State var speedSelector: Bool = false
    @State var showPopUp: Bool = false
    @State var fileName = ""
    @State var transcriptSaved = ""
    @State var transcriptStart = 0
    
    init(blueTooth: BLEController) {
        self.blueTooth = blueTooth
        UITextView.appearance().backgroundColor = .clear
    }
    
    let backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(backgroundColor))
                .ignoresSafeArea()
            VStack {
                NavigationLink("Recordings") {
                    SavedFileVIew()
                }
                if (soundMeterEnable) {
                    NoiseMeterView(soundLevel: Int(speechRecognizer.dB))
                        .frame(width: 300, height: 100)
                }
                Spacer()
                
                VStack (alignment: .leading){
                    Text("Speech Output:")
                        .bold()
                        .foregroundColor(.white)
                    ScrollView(showsIndicators: true){
                        Text(speechRecognizer.transcript)
                            .foregroundColor(Color("TextColor"))
                            .padding()
                    }
                    .frame(width: 300, height: 200, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(.black))
                }
                
                
                // Record Button Setup
                RecordButtonView
                
                Spacer()
                
                //Text Editior View
                VStack(alignment: .leading) {
                    Text("Insert Text:")
                        .bold()
                        .foregroundColor(.white)
                    
                    if !editorChooser {
                        TextEditorView
                    } else {
                        TextEditorView2
                    }
                    Text("\(userText.count)/\(maxCharScreen)")
                }
                
                // Button to send Data
                SendButtonView
                
                
                Spacer()
            }
            // Sending Transcript Data to Arduino
            .onChange(of: speechRecognizer.transcript, perform: { newValue in
                if (isRecording && blueTooth.peripheralConnected) {
                    var sendString = ""
                    // If I hit the limit of the screen
                    
                    if (newValue.count > maxCharScreen * (transcriptStart + 1)) {
                        
                        print("Hello")
                        transcriptStart += 1 // increase start of string
                        var newLineIndex = newValue.index(newValue.startIndex, offsetBy: maxCharScreen * transcriptStart)
                        
                            // checking if I landed on a space
                        if (newValue[newLineIndex] == Character(" ")) {
                            newLineIndex = newValue.index(after: newLineIndex)
                            sendString = String(newValue[newLineIndex...])
                        }
                        
                            // Back Track until I land on character landing at space
                        else {
                            var nextIndex = newValue.index(before: newLineIndex)
                            while (true) {
                                // go back an index
                                if (newValue[nextIndex] == Character(" ")) {
                                    nextIndex = newValue.index(after: nextIndex)
                                    break
                                }
                                nextIndex = newValue.index(before: nextIndex)
                            }
                            sendString = String(newValue[nextIndex...])
                        }
                    }
                    
                    else if (newValue.count > maxCharScreen * transcriptStart){
                        // The Beginning of the transcript
                        if (transcriptStart == 0) {
                            sendString = newValue
                        } else {
                            var newLineIndex = newValue.index(newValue.startIndex, offsetBy: maxCharScreen * transcriptStart)
                            
                                // checking if I landed on a space
                            if (newValue[newLineIndex] == Character(" ")) {
                                newLineIndex = newValue.index(after: newLineIndex)
                                sendString = String(newValue[newLineIndex...])
                            }
                            
                                // Back Track until I land on character landing at space
                            else {
                                var nextIndex = newValue.index(before: newLineIndex)
                                while (true) {
                                    // go back an index
                                    if (newValue[nextIndex] == Character(" ")) {
                                        nextIndex = newValue.index(after: nextIndex)
                                        break
                                    }
                                    nextIndex = newValue.index(before: nextIndex)
                                }
                                sendString = String(newValue[nextIndex...])
                            }
                        }
                    }
                    print(sendString)
                    prevTranscript = newValue
                    
                    let nsString = sendString as NSString
                    guard let sendData = nsString.data(using: String.Encoding.utf8.rawValue) else {
                        print("Can't Convert String to Data")
                        return
                    }
                    
                    // Writing TO Characteristic
                    if let characteristic = blueTooth.textSpeechChar, let peripheral = blueTooth.connectedPeripheral {
                        peripheral.writeValue(sendData,
                                              for: characteristic,
                                              type: .withResponse)
                        
                        
                    }
                    
                }
            })
            
            if (self.showPopUp) {
                GeometryReader {geo in
                    PopUpView(fileName: $fileName, showPopUp: $showPopUp, transcript: $transcriptSaved)
                        .frame(width:geo.size.width, height: geo.size.height)
                        .background(.black.opacity(0.5))
                }
                   
            }
        }
        .navigationBarBackButtonHidden(self.isRecording)
        .onTapGesture {
            hideKeyboard()
        }
        
        // Sending textPlacement Data to Arduino
        .onChange(of: textPlacement,
                  perform: {newValue in
            print("Changing text placement")
            if (blueTooth.peripheralConnected) {
                let placementData = Data(bytes: &textPlacement, count: MemoryLayout.size(ofValue: textPlacement))
                print(placementData)
                // Writing TO Characteristic
                if let characteristic = blueTooth.textPlacementChar, let peripheral = blueTooth.connectedPeripheral {
                    peripheral.writeValue(placementData,
                                          for: characteristic,
                                          type: .withResponse)
                    
                }
            }
        })
        
        // Sending speedSelector Data to Arduino
        .onChange(of: speedSelector, perform: {newValue in
            print("Changing text speed")
            if(blueTooth.peripheralConnected) {
                let speedData = Data(bytes: &speedSelector, count: MemoryLayout.size(ofValue: speedSelector))
                print(speedData)
                if let characteristic = blueTooth.textSpeed, let peripheral = blueTooth.connectedPeripheral {
                    peripheral.writeValue(
                             speedData,
                             for: characteristic,
                             type: .withResponse)
                }
            }
            
        })
        .toolbar(content: {
            Button("Edit", action: {
                showPreference = true
            })
        })
        .onAppear{
            speechRecognizer.resetTranscript()
        }
        
        .sheet(isPresented: $showPreference, onDismiss: {print(showPreference)},content: {
            SpeechEditView(textInput: $editorChooser, textPlacement: $textPlacement, soundMeterEnable: $soundMeterEnable,
            speedSelect: $speedSelector)
        })
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
            if let characteristic = blueTooth.textSpeechChar, let peripheral = blueTooth.connectedPeripheral {
                peripheral.writeValue(sendData,
                                      for: characteristic,
                                      type: .withResponse)
                
            }
        }) {
            Text("Send")
                .font(.title)
                .foregroundColor(.white)
                .padding()
                .background(isRecording || userText.isEmpty || userText.count > maxCharScreen ? Color.blue.opacity(0.5) : Color.blue)
                .cornerRadius(10)
        }
        .disabled(isRecording || userText.isEmpty || userText.count > maxCharScreen)
    }
    
    private var RecordButtonView: some View {
        Button(action: {
            if !isRecording {
                speechRecognizer.startTranscribing()
            } else {
                transcriptStart = 0
                //prevTranscript = ""
                transcriptSaved = speechRecognizer.transcript
                speechRecognizer.stopTranscribing()
                self.showPopUp = true
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
        TextField(text: $userText, label: {Text("Insert Text Here").foregroundColor(.black.opacity(0.4))})
            .foregroundColor(.black)
            .padding(2)
            .frame(width: 300, height: 40)
            .tint(.black)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color.white))
            .padding(10)
            .disabled(isRecording)
    }
    
    private var TextEditorView2: some View {
        TextEditor(text: $userText)
            .frame(width: 300, height: 200)
            //.opacity(0.1)
            .tint(Color("Tint"))
            .cornerRadius(10)
            .disabled(isRecording)
    }
}

struct SpeechRecogView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SpeechRecogView(blueTooth: BLEController())
                //.preferredColorScheme(.dark)
        }
    }
}

