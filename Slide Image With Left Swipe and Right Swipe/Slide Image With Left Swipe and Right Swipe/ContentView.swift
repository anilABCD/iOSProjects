import SwiftUI

struct ContentView: View {
    @State private var currentIndex: Int = 0
    @State private var isHidden: Bool = false
    private let images = ["person.fill", "star.fill"] // Replace with your images

    var body: some View {
        ZStack {
            ForEach(images.indices, id: \.self) { index in
                if index == currentIndex {
                    SwipeableView(
                        imageName: images[index],
                        headline: "Headline \(index + 1)",
                        boldText: "Bold Text \(index + 1)",
                        subText: "Subtext \(index + 1)"
                    ) {
                        withAnimation(.easeIn(duration: 0.5)) {
                            currentIndex = (currentIndex + 1) % images.count
                        }
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct SwipeableView: View {
    let imageName: String
    let headline: String
    let boldText: String
    let subText: String
    let onSwipe: () -> Void
    
    @State private var offset: CGSize = .zero
    @State private var isHidden: Bool = false
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .bottomLeading) {
                Image( systemName: imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.8)
                    .clipped()
                    .offset(x: offset.width, y: 0)
                    .rotationEffect(.degrees(Double(offset.width / 20)))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation
                            }
                            .onEnded { _ in
                                if abs(offset.width) > 100 {
                                    withAnimation {
                                        offset.width > 0 ? swipeRight() : swipeLeft()
                                    }
                                } else {
                                    withAnimation {
                                        offset = .zero
                                    }
                                }
                            }
                    )
                VStack(alignment: .leading) {
                    Text(boldText)
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    Text(subText)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
            }
            Text(headline)
                .font(.headline)
                .padding()
            Spacer()
        }
        .opacity(isHidden ? 0 : 1)
    }

    private func swipeLeft() {
        withAnimation(.easeIn(duration: 0.5)) {
            offset = CGSize(width: -UIScreen.main.bounds.width, height: 0)
            isHidden = true
            onSwipe()
        }
    }

    private func swipeRight() {
        withAnimation(.easeIn(duration: 0.5)) {
            offset = CGSize(width: UIScreen.main.bounds.width, height: 0)
            isHidden = true
            onSwipe()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
