

import SwiftUI
import PhotosUI

struct UploadYourPhotoView: View {
    
    @Binding var path :[MyNavigation<String>]
    
    
    @State private var image : UIImage?
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    
  
    @State private var isUploading : Bool?
    
    @State private var photoPickerItem : PhotosPickerItem?;
    
    var body: some View {
        
        VStack{
            
           
            
        
            VStack{
                
                Spacer()
                
                if( image != nil) {
                    Image(uiImage: image ?? UIImage())
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 200, height: 200)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                else if ( tokenManger.photo != "")
                {
                    AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo)")
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/).frame(width: 200, height: 200)
                }
                else{
                    
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.black)
                        .frame(width: 200, height: 200)
                        .clipShape(.circle)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                
                HStack(spacing:20){
                    
                    PhotosPicker(selection: $photoPickerItem , matching: .images)
                    {
                        
                        Text ("Upload Photo").padding().foregroundColor(.white).background(.blue).cornerRadius(8)
                        
                    }
                }
                
                
                Spacer()
                
            }.frame(maxWidth: .infinity).background(.white)
            
        }.frame(maxWidth: .infinity).navigationTitle("Upload Your Photo")
            .onChange(of: photoPickerItem) { newValue in
                Task {
                    if let photoPickerItem = newValue {
                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
                            
                            if let imagedata = UIImage(data: data){
                                image = imagedata
                              
                                Task {
                                   
                                    await uploadImage()
                        
                                    
                                }
                                
                            }
                            
                            // Process the loaded data asynchronously
                        }
                    }
                   
                    photoPickerItem = nil
                }
            }
    }
    
    
    func uploadImage() async {
        
        
           guard let image = image,
                 let imageData = image.jpegData(compressionQuality: 1.0) else {
               print("No image or failed to convert image to data.")
               return
           }

           guard let url = URL(string: "\(tokenManger.localhost)/user/uploadImage") else {
               print("Invalid URL.")
               return
           }

           var request = URLRequest(url: url)
           request.httpMethod = "POST"

           let boundary = UUID().uuidString
           let fieldName = "myImage"
           let fileName = "image.jpg"
        let token = tokenManger.accessToken;
           request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


           var body = Data()
        
           body.append("--\(boundary)\r\n".data(using: .utf8)!)
           body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
           body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
           body.append(imageData)
           body.append("\r\n".data(using: .utf8)!)
   
           body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
    

           request.httpBody = body
        
      
           do {
               isUploading = true
               
               defer {
                   isUploading = false
               }
               
               let (data, response) = try await URLSession.shared.data(for: request)
               if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                   print("Image uploaded successfully!")
                   
                   if let decodedResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                       // Save token locally
            
                       if let photo = decodedResponse.data?.user?.photo {
                           
                             DispatchQueue.main.async {
                                
                                 tokenManger.updatePhoto(photo: photo)
                                 print("Photo: \(photo)")
                              
                             }
                       } else {
                           print("No Token")
                       }
                      
                  
                   }
                   
//                   uploadResult = "Image uploaded successfully!"
               } else {
                   print("Failed to upload image.")
//                   uploadResult = "Failed to upload image."
               }
               
             
               
           } catch {
               print("Error uploading image: \(error)")
//               uploadResult = "Error uploading image: \(error.localizedDescription)"
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
