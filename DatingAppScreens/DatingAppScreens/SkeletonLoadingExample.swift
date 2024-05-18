import SwiftUI


struct SkeletonLoadingExampleView: View {
    
    
    
    @State private var isSkeletonLoading = true;
    
    
    
    var body: some View {
        
  
            VStack {
                
               Spacer()
                
                Text("Hello World for Skeletop Box ")
                
                Spacer();
                
                
            }.background(.orange).frame(maxWidth:.infinity)
            
                .overlay(
                    Group {
                        if isSkeletonLoading {
                            SkeletonView();
                        }
                    }
                )
            
                .onAppear {
                    Task {
                        // Simulate loading process
                        try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds delay
                        isSkeletonLoading = false
                    }
                }
        
    }
    
}
   
struct SkeletonLoadingView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        SkeletonLoadingExampleView()
    }
}


// Use this code in the View To Implement the Skeleton View . in the Main View overlay :

//    .overlay(
//        Group {
//            if isSkeletonLoading {
//                SkeletonView();
//            }
//        }
//    )
//
//    .onAppear {
//        Task {
//            // Simulate loading process
//            try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds delay
//            isSkeletonLoading = false
//        }
//    }
// code implementing in the view code .

struct SkeletonView: View {
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                SkeletonBox()
                SkeletonBox()
            }
            SkeletonBox()
            SkeletonBox()
            HStack {
                SkeletonBox()
                SkeletonBox()
                SkeletonBox()
            }
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(10)
        .onAppear {
                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                        isAnimating.toggle()
                    }
                }
    }
}

struct SkeletonBox: View {
    @State private var animate = false

       var body: some View {
           Rectangle()
               .fill(LinearGradient(
                   gradient: Gradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.7)]),
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing
               ))

               .cornerRadius(5)
               .shadow(color: Color.black.opacity(0.2), radius: 4, x: 2, y: 2)
               .opacity(animate ? 0.7 : 0.3)
               .onAppear {
                   withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                       animate.toggle()
                   }
               }
       }
}
