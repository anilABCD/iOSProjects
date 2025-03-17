import SwiftUI
import PhotosUI

struct UploadYourPhotoView: View {
    
//    @Binding var path :[MyNavigation<String>]
    
    
    @State private var image : UIImage?
    @State private var tempImage: UIImage? // Add temporary image holder
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var isFirstTimeUpdating = false;
  
    @State private var isUploading : Bool?
    
    @State private var photoPickerItem : PhotosPickerItem?;
    @Environment(\.presentationMode) var presentationMode // For dismissing the view
    
    @State private var resizedImageData: Data?
    @StateObject private var toastManager = ToastManager() // Add toast manager

       
    var showNextButton : Bool = false ;
    
    @State private var showAlert = false; // Alert visibility state

    var body: some View {
        
        VStack{
            
           
            
        
            VStack{
                
                HStack {
                    
                    Text("Upload Your Photo")
                        .font(themeManager.currentTheme.titlefont) // Use .subheadline or .callout for smaller text
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
                    CachedImageView(
                        url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo ?? "image.jpg")"),
                        width: 200,
                        height: 200,
                        failureView: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()  .clipShape(Circle()).frame(width: 200, height: 200)
                            
                        },
                        storeInDisk : true
                    )
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
                        
                        Text ("Upload Photo").modifier(ThemedTextButtonModifier()).padding().frame(width: 300)
                        
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
            .overlay(
                VStack {
                    if toastManager.isShowing {
                        ToastView(message: toastManager.message)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: toastManager.isShowing)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            )
            .onChange(of: photoPickerItem) { newValue in
                Task {
                    if let photoPickerItem = newValue {
                        // Dismiss picker immediately
                        DispatchQueue.main.async {
                            self.photoPickerItem = nil
                        }
                        
                        // Try to load the image data
                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                           let imagedata = UIImage(data: data) {
                            // Store in temporary variable instead of showing immediately
                            self.tempImage = imagedata
                            
                            // Set loading state
                            DispatchQueue.main.async {
                                isUploading = true
                            }
                            
                            // Start upload
                            await uploadImage()
                        }
                    }
                }
            }
            
            // Remove the separate image onChange handler since we're handling upload right after image selection
            
            // Add loading overlay
            .overlay {
                if isUploading == true {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThinMaterial)
                            .edgesIgnoringSafeArea(.all)
                        
                        VStack(spacing: 20) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: themeManager.currentTheme.textColor))
                                .scaleEffect(2.0)
                            
                            Text("Uploading...")
                                .font(.headline)
                                .foregroundColor(themeManager.currentTheme.textColor)
                                .padding(.top, 4)
                        }
                        .padding(30)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(themeManager.currentTheme.backgroundColor.opacity(0.8))
                                .shadow(radius: 10)
                        )
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline).background( themeManager.currentTheme.backgroundColor )
    }
    
    
    func uploadImage() async {
        guard let tempImage = tempImage,
              let imageData = resizeImage(tempImage, maxFileSize: 300 * 1024) else {
            print("No image or failed to convert image to data.")
            DispatchQueue.main.async {
                isUploading = false
                toastManager.showToast(message: "Failed to process image")
            }
            return
        }

        guard let url = URL(string: "\(tokenManger.localhost)/user/uploadImage") else {
            print("Invalid URL.")
            DispatchQueue.main.async {
                isUploading = false
                toastManager.showToast(message: "Invalid URL")
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        let fieldName = "myImage"
        let fileName = "image.jpg"
        let token = tokenManger.accessToken
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
            let (data, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                print("Image uploaded successfully!")
                
                if let rawDataString = String(data: data, encoding: .utf8) {
                    print("Raw response data: \(rawDataString)")
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    print("image decoded successfully")
                    if let photo = decodedResponse.data?.user?.photo {
                        DispatchQueue.main.async {
                            tokenManger.updatePhoto(photo: photo)
                            image = tempImage // Only set the display image after successful upload
                            print("Photo: \(photo)")
                            toastManager.showToast(message: "Image uploaded successfully!")
                        }
                    } else {
                        print("No Token")
                        DispatchQueue.main.async {
                            toastManager.showToast(message: "Failed to update photo")
                        }
                    }
                } catch {
                    print("Failed to decode response: \(error)")
                }
            } else {
                print("Failed to upload image.\(response)")

                 DispatchQueue.main.async {
                        toastManager.showToast(message: "Failed to process server response")
                    }

            }
        } catch {
            print("Error uploading image: \(error)")
              DispatchQueue.main.async {
                isUploading = false
                toastManager.showToast(message: "Error uploading image")
            }
        }
        
        // Always ensure loading state is cleared
        DispatchQueue.main.async {
            isUploading = false
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
