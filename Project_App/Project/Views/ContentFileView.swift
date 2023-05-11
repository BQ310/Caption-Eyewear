//
//  ContentFileView.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 5/7/23.
//

import SwiftUI

struct ContentFileView: View {
    var filePath: URL
    var fileName: String
    @State var fileContents = ""
    var body: some View {
        ScrollView {
            Text(fileContents)
        }.onAppear {
            do {
                fileContents = try String(contentsOf: filePath)
                print(fileContents)
            } catch {
                print(error.localizedDescription)
            }
        }
        .navigationTitle(fileName)
    }
}

struct ContentFileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentFileView(filePath: URL(string: "")!, fileName: "Hello")
        }
    }
}
