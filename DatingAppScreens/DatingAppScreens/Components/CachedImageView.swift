





import SwiftUI

struct CachedImageView<FailureView: View>: View {
    let url: URL?
    let width: CGFloat
    let height: CGFloat
    let failureView: () -> FailureView
  
    var storeInDisk : Bool = false ;
    
  
    var isCircle : Bool = false
    var cacheExpiryInterval : TimeInterval = 60 * 60 * 24 * 7 ;
    
    @State private var image: UIImage?
    @State private var isLoading = true
    @State private var hasFailed = false

    var body: some View {
        Group {
            if let image = image {
                
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .background(.black)
                        .frame(width: width, height: height)
                        .clipped()
                        .cornerRadius( isCircle ? width : 20)
                    
//                    Text( hasFailed ? "Image Failed to Load" : "").foregroundColor(.white)
                }
                    
            } else if isLoading {
                ProgressView()
                    .frame(width: width, height: height)
            } else {
                failureView()
            }
        }
        .onAppear {
            load()
        }
    }

    private func load() {
        
        print("\(url)")
        
        guard let url = url else {
            hasFailed = true
            isLoading = false
            return
        }

        isLoading = true
        hasFailed = false
        
    
        
        loadImage(url: url , storeInDisk : storeInDisk , cacheExpiryInterval: cacheExpiryInterval) { loadedImage in
            
            DispatchQueue.main.async {
                self.isLoading = false
                if let loadedImage = loadedImage {
                    self.image = loadedImage
                } else {
                    self.hasFailed = true
                }
            }
        }
    }
}
