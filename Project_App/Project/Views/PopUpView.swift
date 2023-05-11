//
//  PopUpView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 5/6/23.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct PopUpView: View {
    @Binding var fileName: String
    @Binding var showPopUp: Bool
    @Binding var transcript: String
    let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] // main directory for documents
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
               
                TextField(text: $fileName) {
                    Text("name file...")
                        .foregroundColor(.blue)
                }.multilineTextAlignment(.leading)
                
                .foregroundColor(.black)
                .frame(width: 280, height: 35)
                .background(RoundedRectangle(cornerRadius: 5).fill(.white))
                .padding(30)
                .multilineTextAlignment(.center)
                .frame(width: 300, height: 300)
                .background(RoundedRectangle(cornerRadius: 10).fill(.gray))
            }
            
            // Save Button
            saveButton
                .onTapGesture {
                    // Write transcript to directory
                    let urlPath = directoryPath.appendingPathComponent(fileName, conformingTo: .plainText)
                    
                    do {
                        try transcript.write(to: urlPath, atomically: true, encoding: .utf8)
                    } catch {
                        print(error.localizedDescription)
                    }
                    // Close the PopUp
                    fileName = "" // clear file name
                    transcript = "" // clear transcript
                    showPopUp = false
                }
                .opacity(fileName.count == 0 ? 0.6 : 1)
                .disabled(fileName.count == 0)
            
            
            // Cancel Button
            cancelButton
                .onTapGesture {
                    // Close the PopUp
                    fileName = "" // clear the name
                    transcript = "" // clear the transcript
                    showPopUp = false
                }

        }
    }
    
    var saveButton: some View {
        Rectangle()
            .fill(.cyan)
            .cornerRadius(10, corners: [.bottomLeft])
            .frame(width: 150, height: 100)
            .overlay{
                Text("SAVE")
                    .bold()
                    .foregroundColor(.white)
            }
            .offset(x: -75, y: 100)
    }
    var cancelButton: some View {
        Rectangle()
            .fill(.red)
            .cornerRadius(10, corners: [.bottomRight])
            .frame(width: 150, height: 100)
            .overlay{
                Text("CANCEL")
                    .bold()
                    .foregroundColor(.white)
            }
            .offset(x: 75, y: 100)
    }
}

struct PopUpView_Previews: PreviewProvider {
    static var previews: some View {
        PopUpView(fileName: .constant(""), showPopUp: .constant(true), transcript: .constant(""))
    }
}
