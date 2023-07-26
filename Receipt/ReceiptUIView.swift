//
//  ReceiptUIView.swift
//  Archeality
//
//  Created by Anurag Kaki on 2/20/23.
//

import SwiftUI

struct ReceiptUIView: View {
    @EnvironmentObject var imageData : ImageData
    
    var body: some View {
        List {
            ForEach(imageData.imageNote) { note in
                NavigationLink(destination: NoteDetailView(note: note)) {
                    HStack {
                        Image(uiImage: UIImage(data: note.image)!)
                            .resizable()
                            .frame(width: 50, height: 50, alignment: .center)
                        
                        VStack(alignment: .leading) {
                            Text(note.title)
                                .lineLimit(2)
                        }
                    }
                }
            }
        }
    }
}

struct ReceiptUIView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiptUIView() .environmentObject(ImageData())
    }
}
import SwiftUI

struct NoteDetailView: View {
    @EnvironmentObject var imageData : ImageData
    @State var note: ImageNote
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    Image(uiImage: UIImage(data: note.image)!)
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                    
                    Spacer()
                }
                TextField("Edit me!", text: $note.title)
                    .textSelection(.enabled)
                    .onTapGesture {
                        note.title = ""
                    }
    
                ZStack {
                    TextEditor(text: $note.description)
                        .textSelection(.enabled)
                        .frame(height: 200)
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("\(note.description.count)/120")
                                .foregroundColor(.gray)
                                .padding()
                        }
                    }
                }
                HStack {
                    Spacer()
                    Button("Confirm changes") {
                        imageData.editNote(id: note.id, title: note.title, description: note.description)
                        presentationMode.wrappedValue.dismiss()
                    }
                    Spacer()
                }
            }
        }
    }
}

struct NoteDetailView_Previews: PreviewProvider {
    static var previews: some View {
    let tempImage = UIImage(systemName: "map")?.pngData()
        
        NoteDetailView(note: ImageNote(id: UUID(), image: tempImage!, title: "Test", description: "Test Description"))
            .environmentObject(ImageData())
    }
}

//
//  ContentView.swift
//  iReceipt
//
//  Created by Federico on 26/01/2022.
//

import SwiftUI

struct ReceiptStarting: View {
    @StateObject var imageData = ImageData()
    @State var showImagePicker: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                if imageData.imageNote.isEmpty {
                    Text("Add an image to take notes!")
                        .italic()
                        .foregroundColor(.gray)
                } else {
                    ReceiptUIView()
                }
            }
            .navigationTitle("Measurement Notes")
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: .photoLibrary) { image in
                    imageData.addNote(image: image,
                                      title: "Edit me!",
                                      desc: "")
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showImagePicker.toggle()
                    } label: {
                        Label("Image", systemImage: "photo.on.rectangle.angled")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            imageData.resetUserData()
                        }
                    } label: {
                        Label("Image", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
        }
        .environmentObject(imageData)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode)
    private var presentationMode
    
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    
    final class Coordinator: NSObject,
                             UINavigationControllerDelegate,
                             UIImagePickerControllerDelegate {
        
        @Binding
        private var presentationMode: PresentationMode
        private let sourceType: UIImagePickerController.SourceType
        private let onImagePicked: (UIImage) -> Void
        
        init(presentationMode: Binding<PresentationMode>,
             sourceType: UIImagePickerController.SourceType,
             onImagePicked: @escaping (UIImage) -> Void) {
            _presentationMode = presentationMode
            self.sourceType = sourceType
            self.onImagePicked = onImagePicked
        }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            onImagePicked(uiImage)
            presentationMode.dismiss()
            
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            presentationMode.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentationMode: presentationMode,
                           sourceType: sourceType,
                           onImagePicked: onImagePicked)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
    
}

