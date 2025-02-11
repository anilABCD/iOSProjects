

import SwiftUI
import PhotosUI

struct UploadYourPhotoView: View {
    
//    @Binding var path :[MyNavigation<String>]
    
    
    @State private var image : UIImage?
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var isFirstTimeUpdating = false;
  
    @State private var isUploading : Bool?
    
    @State private var photoPickerItem : PhotosPickerItem?;
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
       
    var showNextButton : Bool = false ;
    
    @State private var showAlert = false; // Alert visibility state

    var body: some View {
        
        VStack{
            
           
            
        
            VStack{
                
                HStack {
                    
                    Text("Upload Your Photo")
                        .font(.title) // Use .subheadline or .callout for smaller text
                        .modifier(ThemedTextModifier())
                 
                    Spacer();
                    
                }.padding()
                
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
                        .clipShape(Circle()).frame(width: 200, height: 200)
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
                        
                        Text ("Upload Photo").padding().foregroundColor(.white).background(themeManager.currentTheme.buttonColor).cornerRadius(8)
                        
                    }
                }
                
                Spacer()
                Spacer()
                
                if showNextButton {
                
                    Button("Next" , action: {
                        
                        if image == nil && tokenManger.photo == "" {
                            
                            // Show alert if no image is selected
                            showAlert = true
                        }
                        else {
                            
                            tokenManger.nextButtonWhenRegistrationProcess = UUID();
                        }
                    }).buttonStyle(ThemedButtonStyle()).padding(.horizontal)
                    
//                    {
//                        Text("Next")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, maxHeight: 50)
//                            .background(Color.blue)
//                            .cornerRadius(10)
//                    }
                    .padding()
                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("Image Missing"),
                                            message: Text("Please select or upload an image before proceeding."),
                                            dismissButton: .default(Text("OK"))
                                        )
                                    }
                }
                
            }.frame(maxWidth: .infinity) 
            
        }.frame(maxWidth: .infinity).background( themeManager.currentTheme.backgroundColor ) // Keeps the back button
           
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
            } .navigationBarTitle("", displayMode: .inline).background( themeManager.currentTheme.backgroundColor ) // Keeps the back button
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
                   
                   // Print the raw data for debugging
                   if let rawDataString = String(data: data, encoding: .utf8) {
                       print("Raw response data: \(rawDataString)")
                   }
                   
                   do {
                       let decodedResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                           // Save token locally
                           print ("image decoded successfully")
                           if let photo = decodedResponse.data?.user?.photo {
                               
                               DispatchQueue.main.async {
                                   
                                   tokenManger.updatePhoto(photo: photo)
                                   print("Photo: \(photo)")
                                   
                               }
                           } else {
                               print("No Token")
                           }
                           
                           
                       
                       
                   }
                   catch {
                       print("Failed to decode response: \(error)")
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

//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable

    static var previews: some View {
        UploadYourPhotoView( ).environmentObject(TokenManager())
//        UploadYourPhotoView()
    }
}
