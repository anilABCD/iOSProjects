import SwiftUI

struct SplashScreenView: View {
    @AppStorage("selectedThemeID") private var selectedThemeID: String = "light"

    var body: some View {
        VStack {
            Image("splashscreenlogo")
                .resizable()
                .frame(width: 300, height: 189)
                .cornerRadius(20)
//            Text("Welcome To Devos Dating App")
//                .font(.subheadline)
//                .fontWeight(.bold)
////            
//            Text("Devos Dating App")
//                .font(.subheadline)
//                .fontWeight(.bold)
        }
        .frame( maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/ , maxHeight:.infinity)
        .background(selectedThemeID == "light" ? Color.white : Color.black )
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    SplashScreenView()
}
