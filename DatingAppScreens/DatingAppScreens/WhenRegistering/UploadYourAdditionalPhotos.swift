//
//  UploadYourAdditionalPhotos.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 02/02/25.
//



import SwiftUI
import PhotosUI


struct ImageUploaderView: View {
    
    var imageNumber : Int ;
    
    @Binding var image: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showAlert = false
    
    
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    @State private var isFirstTimeUpdating = false;
  
    @State private var isUploading : Bool?
    
    var showNextButton : Bool = false ;
    
    
    let title: String
    
    var body: some View {
        VStack {
            HStack {
                Text(title)
                    .font(.title)
                    .foregroundColor(.primary)
                Spacer()
            }.padding(.horizontal)
            
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            else if (
                ( imageNumber == 1 && tokenManger.photo1 != "" ) ||
                ( imageNumber == 2 && tokenManger.photo2 != "" ) ||
                ( imageNumber == 3 && tokenManger.photo3 != "" ) ||
                ( imageNumber == 4 && tokenManger.photo4 != "" )
            ) {
                
                switch imageNumber {
                case 1 : AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo1)")
                        .clipShape(Circle()).frame(width: 100, height: 100)
                case 2 : AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo2)")
                        .clipShape(Circle()).frame(width: 100, height: 100)
                case 3 : AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo3)")
                        .clipShape(Circle()).frame(width: 100, height: 100)
                case 4 : AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo4)")
                        .clipShape(Circle()).frame(width: 100, height: 100)
                default:
                    Image(systemName: "person.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(.black)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                }
                
               
            } else {
                Image(systemName: "person.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .foregroundColor(.black)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 1))
            }
            
            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                Text("Upload Photo").padding().foregroundColor(.white).background(.blue).cornerRadius(8)
            }
            
        }
        .onChange(of: photoPickerItem) { newValue in
            Task {
                if let photoPickerItem = newValue,
                   let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                   let imagedata = UIImage(data: data) {
                    image = imagedata
                    await uploadImage()
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

           guard let url = URL(string: "\(tokenManger.localhost)/user/uploadPhotosAdditional") else {
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
        
        request.setValue("\(imageNumber)", forHTTPHeaderField: "X-Image-Number")

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
                                   
                                   
                                   switch imageNumber {
                                    
                                   case 1 : tokenManger.updatePhoto1(photo: photo)
                                   case 2 : tokenManger.updatePhoto2(photo: photo)
                                   case 3 : tokenManger.updatePhoto3(photo: photo)
                                   case 4 : tokenManger.updatePhoto4(photo: photo)
                                       
                                   default:
                                       break
                                   }
                                   
                                  
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
}


struct UploadYourAdditionalPhotosView: View {
    
//    @Binding var path :[MyNavigation<String>]
    
    
    @State private var image1 : UIImage?
    @State private var image2 : UIImage?
    @State private var image3 : UIImage?
    @State private var image4 : UIImage?
    
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var isFirstTimeUpdating = false;
  
    @State private var isUploading : Bool?
    
    @State private var photoPickerItem : PhotosPickerItem?;
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
       
    var showNextButton : Bool = false ;
    
    @State private var showAlert = false; // Alert visibility state
    @State private var isLoaded = false

    let columns = [
          GridItem(.flexible()),
          GridItem(.flexible()) // Two flexible columns
      ]
      
    var body: some View {
        
        VStack{
           
            HStack {
                Text("Addtional Photos to attract more users").font(.subheadline).padding()
                Spacer()
            }
            LazyVGrid(columns: columns, spacing: 16) {
                if isLoaded { // Views appear when isLoaded becomes true
                    ImageUploaderView(imageNumber: 1, image: $image1, title: "Photo 1")
                    ImageUploaderView(imageNumber: 2, image: $image2, title: "Photo 2")
                    ImageUploaderView(imageNumber: 3, image: $image3, title: "Photo 3")
                    ImageUploaderView(imageNumber: 4, image: $image4, title: "Photo 4")
                }
                        }
            .padding().background( themeManager.currentTheme.backgroundColor)
        
//            VStack{
                
//                HStack {
//                
//                    Text("Upload Your Photo")
//                        .font(.title) // Use .subheadline or .callout for smaller text
//                        .foregroundColor(.primary)
//                    
//                    Spacer();
//                    
//                }.padding()
//                
//                Spacer()
//                
//                if( image != nil) {
//                    Image(uiImage: image ?? UIImage())
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 200, height: 200)
//                        .clipShape(.circle)
//                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
//                }
//                else if ( tokenManger.photo != "")
//                {
//                    AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo)")
//                        .clipShape(Circle()).frame(width: 200, height: 200)
//                }
//                else{
//                    
//                    Image(systemName: "person.fill")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .foregroundColor(.black)
//                        .frame(width: 200, height: 200)
//                        .clipShape(.circle)
//                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
//                }
//                
//                HStack(spacing:20){
//                    
//                    PhotosPicker(selection: $photoPickerItem , matching: .images)
//                    {
//                        
//                        Text ("Upload Photo").padding().foregroundColor(.white).background(.blue).cornerRadius(8)
//                        
//                    }
//                }
//                
//                
//                Spacer()
//
            
            Spacer()
                if showNextButton {
                
                    Button(action: {
                        
                        if tokenManger.photo1 == "" || tokenManger.photo2 == "" || tokenManger.photo3 == "" ||   tokenManger.photo4 == "" {
                            
                            // Show alert if no image is selected
                            showAlert = true
                        }
                        else {
                            
                            
                            tokenManger.isAdditionalPhotosAdded = true ;
                            
                            tokenManger.nextButtonWhenRegistrationProcess = UUID();
                            
                            
                        }
                    }) {
                        Text("Next")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding()
                    .alert(isPresented: $showAlert) {
                                        Alert(
                                            title: Text("Image Missing"),
                                            message: Text("Please select or upload all images before proceeding."),
                                            dismissButton: .default(Text("OK"))
                                        )
                                    }
                }
                
//            }.frame(maxWidth: .infinity).background(.white)
            
        }.frame( maxHeight: .infinity ).background( themeManager.currentTheme.backgroundColor)
            .onAppear {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLoaded = true // Triggers animation
                }
            }
        
//        .frame(maxWidth: .infinity)
//           
//            .onChange(of: photoPickerItem) { newValue in
//                Task {
//                    if let photoPickerItem = newValue {
//                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self) {
//                            
//                            if let imagedata = UIImage(data: data){
//                                image = imagedata
//                              
//                                Task {
//                                   
//                                    await uploadImage()
//                        
//                                    
//                                }
//                                
//                            }
//                            
//                            // Process the loaded data asynchronously
//                        }
//                    }
//                   
//                    photoPickerItem = nil
//                }
//            } .navigationBarTitle("", displayMode: .inline) // Keeps the back button
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

struct UploadYourAdditionalPhotosView_Previews: PreviewProvider {

//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable

    static var previews: some View {
        UploadYourAdditionalPhotosView( ).environmentObject(TokenManager())
//        UploadYourPhotoView()
    }
}
