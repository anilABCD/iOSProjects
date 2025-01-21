//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 11/05/24.
//

import SwiftUI

struct UserSettingsView : View {

    @EnvironmentObject private var tokenManger : TokenManager
    
    @Binding var path :[MyNavigation<String>]
    

    
  
    @State var items : [String] = ["Photo", "Technologies"]
    
    var body: some View {
     
        NavigationView {
            VStack {
                AsyncImageView(photoURL: "\(tokenManger.localhost)/images/\(tokenManger.photo)").frame(width: 200, height: 200).clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                   
                Form {
                    Section(header: Text("User Profile")) {
                        NavigationLink(destination: UploadYourPhotoView()) {
                            Text("Photo")
                        } 
                        NavigationLink(destination: UpdateTechnologyNewView()) {
                            Text("Technologies")
                        }
                        
                        NavigationLink(destination: UpdateHobbiesView()) {
                            Text("Hobbies")
                        }
                        
                        NavigationLink(destination: UpdateSmokingAndDrinkingAndDOBView()) {
                            Text("Dob , Habbits")
                        }
                        
                        NavigationLink(destination: UpdateDescribeYourselfView ()) {
                            Text("Bio")
                        }
                        
                        NavigationLink(destination: UpdateJobRoleView ()) {
                            Text("Job Role")
                        }
                    }
                    
                    //                          Section(header: Text("Appearance")) {
                    //                              NavigationLink(destination: AppearanceSettingsView()) {
                    //                                  Text("Theme")
                    //                              }
                    //                              NavigationLink(destination: FontSettingsView()) {
                    //                                  Text("Font")
                    //                              }
                    //                          }
                }
            }.navigationBarTitle("Profile Settings").onAppear(){
                
                
                tokenManger.isMenuView = true;
                
            }
          
          
            
        }  .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: BackButton {
                // Handle back button action
                tokenManger.isMenuView = false;
                path.removeLast()
            })

    }
}


struct  UserSettingsView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        UserSettingsView(path: $path).environmentObject(TokenManager())
    }
}




struct AsyncImageView: View {
    
    var photoURL :String = ""
    
    init(photoURL: String) {
        self.photoURL = photoURL
    }
    
    var body: some View {
        // AsyncImage loading the image from a URL
        AsyncImage(url: URL(string: photoURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode:.fill)
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fill
                    )
            @unknown default:
                EmptyView()
            }
        }
    }
}
