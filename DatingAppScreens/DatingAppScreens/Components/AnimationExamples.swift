//
//  ContentView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 02/03/25.
//


import SwiftUI

struct  MovingAnimationView: View {
    @State private var moveToPointB = false

    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .offset(x: moveToPointB ? 150 : -150, y: 0) // Moves horizontally
                .animation(.easeInOut(duration: 1), value: moveToPointB)

            Spacer()

            Button("Animate") {
                moveToPointB.toggle()
            }
            .padding()
        }
    }
}

 
struct SimpleAnimationView: View {
    @State private var isVisible = false

    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
                .opacity(isVisible ? 1.0 : 0.2) // Change opacity
                .animation(.easeInOut(duration: 1), value: isVisible)

            Button("Toggle") {
                isVisible.toggle()
            }
            .padding()
        }
    }
}

struct TransitionAnimationView: View {
    @State private var show = false

    var body: some View {
        VStack {
            if show {
                Text("Hello, SwiftUI!")
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .transition(.scale.combined(with: .opacity)) // Custom transition
            }

            Button("Toggle View") {
                withAnimation(.easeInOut) {
                    show.toggle()
                }
            }
            .padding()
        }
    }
}

struct KeyframeAnimationView: View {
    @State private var position = false

    var body: some View {
        Circle()
            .fill(Color.purple)
            .frame(width: 50, height: 50)
            .offset(y: position ? -200 : 200)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: position)
            .onAppear {
                position.toggle()
            }
    }
}


struct PointAnimationView: View {
    @State private var moveToPointB = false

    var body: some View {
        VStack {
            Spacer()

            Circle()
                .fill(Color.blue)
                .frame(width: 50, height: 50)
                .position(moveToPointB ? CGPoint(x: 300, y: -400) : CGPoint(x: 100, y: 200)) // Moves between two points
                .animation(.easeInOut(duration: 1), value: moveToPointB)

            Spacer()

            Button("Move") {
                moveToPointB.toggle()
            }
            .padding()
        }
    }
}



#Preview {
    MovingAnimationView()
    SimpleAnimationView()
    TransitionAnimationView()
    KeyframeAnimationView()
    PointAnimationView()
}
