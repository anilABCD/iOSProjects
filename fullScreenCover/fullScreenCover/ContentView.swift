import SwiftUI

struct ContentView: View {
    @State private var showFullScreen = false

    var body: some View {
        VStack ( alignment: .leading,   spacing: 10  ) {
            Text("OverLay")
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Button("Show Full Screen Sheet") {
                showFullScreen.toggle()
            }
            Spacer()
        }.frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .leading)
        .overlay (
            showFullScreen ?
                           ZStack {
                               // Transparent Full-Screen Background
                               Color.white.opacity(0.5)
//                                   .edgesIgnoringSafeArea(.all)
                                   .onTapGesture {
                                       showFullScreen = false
                                   }

                               // Centered Transparent Full Screen View
                               TransparentFullScreenView {
                                   showFullScreen = false
                               }
                           }.frame(width: UIScreen.main.bounds.width , height: UIScreen.main.bounds.height + 100 )
                       : nil
        )
        
        
    }
}

struct TransparentFullScreenView: View {
    var dismiss: () -> Void

    var body: some View {
        ZStack {
            // Transparent Background
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    dismiss() // Tap to dismiss
                }
            
            VStack {
                Text("Custom Full Screen")
                    .font(.title)
                    .padding()

                Button("Close") {
                    dismiss()
                }
            }
            .frame(width: 300, height: 200)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
        }
        .background(TransparentView()) // Make fullScreenCover background transparent
    }
}

// UIKit UIView to make background transparent
struct TransparentView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


#Preview {
    ContentView()
}
