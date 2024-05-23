

import SwiftUI
import PhotosUI

struct UploadYourPhotoView: View {
    
    @Binding var path :[MyNavigation<String>]
    
    
    @State private var avatarImage : UIImage?
    
    @State private var photoPickerItem : PhotosPickerItem?;
    
    var body: some View {
        
        VStack{
            
            HStack(spacing:20){
                
                PhotosPicker(selection: $photoPickerItem , matching: .images)
                {
                    Image(uiImage: avatarImage  ?? UIImage( resource: .filter ) )
                        .resizable()
                        .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                        .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                    //                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: 0)
                    
                }
                
                
                
                VStack(alignment: .leading){
                    Text("Sean Allen")
                    
                    Text("iOS Developer")
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
            }
            
            Spacer()
            
            
            
        }.padding(20)
            .onChange(of: photoPickerItem) { newValue in
                Task {
                    if let photoPickerItem = newValue {
                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                            
                            if let image = UIImage(data: data){
                                avatarImage = image
                            }
                            
                            // Process the loaded data asynchronously
                        }
                    }
                    
                    photoPickerItem = nil
                }
            }
    }
    
    //    Button(action: {
    //   //                         requestPhotoLibraryPermission()
    //   //                                     })
    //   //                      {
    //   //                                         VStack {
    //   //                                             Image(systemName: "arrow.up.circle.fill")
    //   //                                                 .resizable()
    //   //                                                 .frame(width: 60, height: 60)
    //   //                                             Text("Upload Photo")
    //   //                                                 .font(.title2)
    //   //                                                 .padding(.top, 8)
    //   //                                         }
    //   //                                         .padding()
    //   //                                     }
    //   //                      .sheet(isPresented: $isPickerPresented, onDismiss: handleSheetDismiss) {
    //   //                          PhotoPicker(selectedImage: $selectedImage)
    //   //
    //   //                      }
    //   //                            .frame(minWidth: 300).background(.blue).foregroundColor(.white).cornerRadius(20)
    
}

struct UploadPhotoView_Previews: PreviewProvider {

    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable

    static var previews: some View {
        UploadYourPhotoView(path: $path)
//        UploadYourPhotoView()
    }
}
