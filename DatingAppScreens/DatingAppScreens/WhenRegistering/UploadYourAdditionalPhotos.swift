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
    var onUploadStatus: (String) -> Void // Add callback for upload status
    
    @Binding var image: UIImage?
    @State private var photoPickerItem: PhotosPickerItem?
    @State private var showAlert = false
    @State private var tempImage: UIImage? // Temporary image holder
    
    
    @EnvironmentObject private var tokenManger : TokenManager
    @EnvironmentObject private var themeManager : ThemeManager
    
    @State private var isFirstTimeUpdating = false;
  
    @State private var isUploading : Bool?
    
    var showNextButton : Bool = false ;
    
    
    let title: String
    
    var body: some View {
        
        ZStack {
            
            // Dashed Border
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    Color.blue,
                    style: StrokeStyle(lineWidth: 2, dash: [6])
                )
                .frame(width: 130) // Adjust size
                .background(Color.blue.opacity(0.1)) // Light blue background
               
                .cornerRadius(12)
            
            VStack {
                HStack {
                    Spacer()
                    Text(title)
                        .font(themeManager.currentTheme.subHeadLinefont)
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
                    case 1 :
                        
                            CachedImageView(
                                url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo1 ?? "image.jpg")"),
                                width: 100,
                                height: 100,
                                failureView: {
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()  .clipShape(Circle()).frame(width: 100, height: 100)
                                    
                                },
                                storeInDisk : true
                            )
                                .clipShape(Circle()).frame(width: 100, height: 100)
                           
                        
                    case 2 :  CachedImageView(
                        url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo2 ?? "image.jpg")"),
                        width: 100,
                        height: 100,
                        failureView: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()  .clipShape(Circle()).frame(width: 100, height: 100)
                            
                        },
                        storeInDisk : true
                    )
                        .clipShape(Circle()).frame(width: 100, height: 100)
                   
                    case 3 :  CachedImageView(
                        url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo3 ?? "image.jpg")"),
                        width: 100,
                        height: 100,
                        failureView: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()  .clipShape(Circle()).frame(width: 100, height: 100)
                            
                        },
                        storeInDisk : true
                    )
                        .clipShape(Circle()).frame(width: 100, height: 100)
                   
                    case 4 :  CachedImageView(
                        url: URL(string: "\(tokenManger.serverImageURL)/\(tokenManger.photo4 ?? "image.jpg")"),
                        width: 100,
                        height: 100,
                        failureView: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()  .clipShape(Circle()).frame(width: 100, height: 100)
                            
                        },
                        storeInDisk : true
                    )
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
                    Text("Upload").modifier(ThemedTextButtonModifier())
                }.disabled(isUploading == true)
                
            }
            .onChange(of: photoPickerItem) { newValue in
                if let photoPickerItem = newValue {
                    // Close the picker immediately
                    DispatchQueue.main.async {
                        self.photoPickerItem = nil
                        self.isUploading = true
                    }

                    Task {
                        if let data = try? await photoPickerItem.loadTransferable(type: Data.self),
                           let imagedata = UIImage(data: data) {
                            // Store in temporary variable
                            self.tempImage = imagedata
                            // Start upload
                            await uploadImage()
                        }
                    }
                }
            }
            
            // Loading Overlay
            if isUploading == true {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    
                    Text("Uploading...")
                        .foregroundColor(.white)
                        .padding(.top, 10)
                }
            }
            
            
        }
    }
    
    
    func uploadImage() async {
        guard let tempImage = tempImage,
              let imageData = resizeImage(tempImage, maxFileSize: 300 * 1024) else {
            print("No image or failed to convert image to data.")
            DispatchQueue.main.async {
                isUploading = false
                onUploadStatus("Failed to process image") // Use callback instead
            }
            return
        }

        guard let url = URL(string: "\(tokenManger.localhost)/user/uploadPhotosAdditional") else {
            print("Invalid URL.")
            DispatchQueue.main.async {
                isUploading = false
                onUploadStatus("Invalid URL") // Use callback instead
            }
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
                                
                                case 1: 
                                    tokenManger.updatePhoto1(photo: photo)
                                    image = tempImage
                                case 2: 
                                    tokenManger.updatePhoto2(photo: photo)
                                    image = tempImage
                                case 3: 
                                    tokenManger.updatePhoto3(photo: photo)
                                    image = tempImage
                                case 4: 
                                    tokenManger.updatePhoto4(photo: photo)
                                    image = tempImage
                                default:
                                    break
                                }
                                
                               
                                print("Photo: \(photo)")
                                onUploadStatus("Photo \(imageNumber) uploaded successfully!") // Use callback instead
                                
                            }
                        } else {
                            print("No Token")
                            DispatchQueue.main.async {
                                onUploadStatus("Failed to update photo") // Use callback instead
                            }
                        }
                        
                        
                
                
                }
                catch {
                    print("Failed to decode response: \(error)")
                    DispatchQueue.main.async {
                        onUploadStatus("Failed to process server response") // Use callback instead
                    }
                }
                
            } else {
                print("Failed to upload image.")
                DispatchQueue.main.async {
                    onUploadStatus("Failed to upload image") // Use callback instead
                }
            }
            
            DispatchQueue.main.async {
                isUploading = false
            }
            
        } catch {
            print("Error uploading image: \(error)")
            DispatchQueue.main.async {
                isUploading = false
                onUploadStatus("Error uploading image") // Use callback instead
            }
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
      
    @StateObject private var toastManager = ToastManager() // Add toast manager here
    
    var body: some View {
        
        VStack{
           
            HStack {
                Text("Addtional Photos to attract more users").font(themeManager.currentTheme.subHeadLinefont).padding()
                Spacer()
            }
            LazyVGrid(columns: columns, spacing: 16) {
                if isLoaded { // Views appear when isLoaded becomes true
                    ImageUploaderView(imageNumber: 1, onUploadStatus: showToast, image: $image1, title: "1").frame(width: 130 )
                    ImageUploaderView(imageNumber: 2, onUploadStatus: showToast, image: $image2, title: "2").frame(width: 130)
                    ImageUploaderView(imageNumber: 3, onUploadStatus: showToast, image: $image3, title: "3").frame(width: 130 )
                    ImageUploaderView(imageNumber: 4, onUploadStatus: showToast, image: $image4, title: "4").frame(width: 130 )
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
                            
                    }.buttonStyle(ThemedButtonStyle())
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
            } .overlay(
                VStack {
                    if toastManager.isShowing {
                        ToastView(message: toastManager.message)
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .animation(.easeInOut(duration: 0.3), value: toastManager.isShowing)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            )
        
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
    
    // Function to show toast message
    private func showToast(_ message: String) {
        toastManager.showToast(message: message)
    }
}

struct UploadYourAdditionalPhotosView_Previews: PreviewProvider {

//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable

    static var previews: some View {
        UploadYourAdditionalPhotosView( ).environmentObject(TokenManager())
//        UploadYourPhotoView()
    }
}
