

import SwiftUI
import PhotosUI

struct ProfileView: View {
  
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    @Binding var path :[MyNavigation<String>]
    
   
    
    var body: some View {
        
        VStack{
            
             Text("Profile View")
           
        }.onAppear(){
            tokenManger.isMenuView = true;
        }.onDisappear(){
            tokenManger.isMenuView = false;
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton {
            // Handle back button action
            tokenManger.isMenuView = false;
            path.removeLast()
        })
    }
    
    
    
}


struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
        }
    }
}

struct ProfileoView_Previews: PreviewProvider {

    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    

    static var previews: some View {
        ProfileView(path: $path).environmentObject(TokenManager())
//        UploadYourPhotoView()
    }
}
