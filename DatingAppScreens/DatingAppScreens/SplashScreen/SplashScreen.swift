import SwiftUI

struct SplashScreenView: View {
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
        .background(Color(red: 20 , green: 20, blue : 20))
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    SplashScreenView()
}
