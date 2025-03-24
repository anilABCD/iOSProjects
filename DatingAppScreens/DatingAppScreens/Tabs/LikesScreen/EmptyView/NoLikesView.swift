//
//  NoLikesView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 24/03/25.
//


import SwiftUI

struct NoLikesView: View {
    @State private var animate = false
    
    @EnvironmentObject var tokenManager : TokenManager
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.8), Color.blue.opacity(0.8)]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            

//                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Animated Heart
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.pink)
                    .shadow(radius: 10)
                    .scaleEffect(animate ? 1.1 : 1.0)
                    .animation(Animation.easeInOut(duration: 1.2).repeatForever(), value: animate)
                
                // Text Message
                Text("No Likes Yet!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Keep exploring and your special someone might be just a swipe away! 💕")
                    .font(.body)
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // CTA Button
                Button(action: {
                    print("Explore More Tapped")
                    
                    tokenManager.selectedTab = 0
                }) {
                    Text("Explore More")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 200)
                        .background(BlurView(style: .dark))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 5)
                } 
                .padding(.top, 10)
            }
            .onAppear {
                animate.toggle()
            }
        }
    }
}

// Blur Effect for Stylish Look
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct NoLikesView_Previews: PreviewProvider {
    static var previews: some View {
        NoLikesView()
    }
}
