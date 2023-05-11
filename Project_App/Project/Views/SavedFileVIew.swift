//
//  SavedFileVIew.swift
//  Project
//
//  Created by Fabert Ottelo Charles on 5/7/23.
//

import SwiftUI

class FileData: Identifiable {
    let id = UUID()
    var fileName: String
    var filePath: URL
    
    init(fileName: String, filePath: URL) {
        self.fileName = fileName
        self.filePath = filePath
    }
}



struct SavedFileVIew: View {
    @State var fileList: [FileData] = []
    @Environment(\.editMode) private var editMode
    init() {
        do {
            let files = try FileManager.default.contentsOfDirectory(at: mainDir, includingPropertiesForKeys: nil)
            var newFiles: [FileData] = []
            for file in files {
                let filePathNoExt = file.deletingPathExtension()
                let fileName = filePathNoExt.lastPathComponent
                let fileData = FileData(fileName: fileName, filePath: file)
                newFiles.append(fileData)
            }
            _fileList = State(initialValue: newFiles)
        } catch {
            print(error.localizedDescription)
        }
    }
    let mainDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var body: some View {
        List {
            ForEach(fileList) { file in
                NavigationLink(file.fileName) {
                    ContentFileView(filePath: file.filePath, fileName: "\(file.fileName)")
                }
            }
            .onDelete(perform: delete)
        }
        .toolbar{EditButton()}
        .navigationTitle("Recordings")
    }
    
    func delete(at offsets: IndexSet) {
        for offset in offsets {
            let file = fileList[offset]
            do {
                try FileManager.default.removeItem(at: file.filePath)
            } catch {
                print(error.localizedDescription)
            }
        }
        fileList.remove(atOffsets: offsets)
    }
}

struct SavedFileVIew_Previews: PreviewProvider {
    static var previews: some View {
        
        NavigationView {
            SavedFileVIew()
        }
    }
}
