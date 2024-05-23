import SwiftUI
import PhotosUI

struct UploadYourImageView: View {
    @State private var selectedImage: UIImage? = nil
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            // Cancel button and title
            HStack {
              
                Spacer()
                
                Text("Upload a Photo")
                    .font(.headline)
                    .padding()
                
                Spacer()
                

            }
            
            Spacer()
            
            // Upload button
            HStack {
                
                Button(action: {
                    isPickerPresented = true
                }) {
                    VStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                        Text("Upload Your Photo")
                            .font(.title2)
                            .padding(.top, 8)
                    }
                    .padding()
                }
                .sheet(isPresented: $isPickerPresented) {
                    PhotoPicker(selectedImage: $selectedImage)
                }
            }.frame(minWidth: 300).background(.blue).foregroundColor(.white).cornerRadius(20)
            
            Spacer()
            
            
            
            Spacer()
        }
    }
}

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let provider = results.first?.itemProvider else { return }

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { (image, error) in
                    DispatchQueue.main.async {
                        self.parent.selectedImage = image as? UIImage
                    }
                }
            }
        }
    }
}

struct UploadPhotoView_Previews: PreviewProvider {
    static var previews: some View {
        UploadYourImageView()
    }
}
