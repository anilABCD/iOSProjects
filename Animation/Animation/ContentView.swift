//
//  ContentView.swift
//  Animation
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var isExpanded = false
    @State private var isLarge = false
    @State private var isRed = false
    @State private var showFirstText = true
    @State private var isJumping = false // State to control the jump
    @State private var isJumped = false // State to control the jump
    
    private let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect() // Timer to trigger every 1 second

    
    var body: some View {
        Circle()
            .frame(width: isExpanded ? 200 : 100, height: isExpanded ? 200 : 100)
            .foregroundColor(.blue)
            .onTapGesture {
                withAnimation {
                    isExpanded.toggle()
                }
            }
        
        Text("Tap me!")
            .font(isLarge ? .largeTitle : .body) // Change font size based on state
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.5)) {
                    isLarge.toggle()
                }
            }
        
        Text("Change my color!")
            .foregroundColor(isRed ? .red : .blue).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/) // Toggle text color
            .onTapGesture {
                withAnimation {
                    isRed.toggle()
                }
            }
        
        VStack {
            if showFirstText {
                Text("First Text")
                    .transition(.slide) // Slide transition for appearing and disappearing text
            } else {
                Text("Second Text")
                    .transition(.slide)
            }
            
            Button("Toggle Text") {
                withAnimation {
                    showFirstText.toggle()
                }
            }
        }
        
        Text("Jump!")
            .font(.largeTitle)
            .bold()
            .offset(y: isJumping ? -50 : 0) // Shift the text up when jumping
            .animation(.interpolatingSpring(stiffness: 100, damping: 5)) // Spring animation for the jump
            .onTapGesture {
                withAnimation {
                    isJumping.toggle() // Toggle the jump state on tap
                }
            }
        
        VStack {
            Text("Jump!")
                .font(.largeTitle)
                .bold()
                .offset(y: isJumped ? -50 : 0) // Move up when "jumped", return to 0 when not
                .animation(.interpolatingSpring(stiffness: 120, damping: 8)) // Spring animation for smooth motion
                .onTapGesture {
                    withAnimation {
                        isJumped.toggle() // Toggle jump state on tap
                    }
          
                }
        }
        
//        Text("Jump!")
//                   .font(.largeTitle)
//                   .bold()
//                   .offset(y: isJumped ? -50 : 0) // Move text up when jumped
//                   .animation(.interpolatingSpring(stiffness: 120, damping: 8), value: isJumped) // Spring animation for jump
//                   .onReceive(timer) { _ in
//                       isJumped.toggle() // Toggle the jump state every time the timer fires
//                   }
//        
        
        
        Circle()
                       .fill(isJumped ? Color.green : Color.red) // Change color on toggle
                       .frame(width: 100, height: 100)
                       .offset(y: isJumped ? -100 : 0) // Jump up or return to original position
                       .animation(.easeInOut(duration: 1), value: isJumped) //
                       .onTapGesture {
                           withAnimation {
                               isJumped.toggle() // Toggle jump state on tap
                           }
                 
                       }//Smooth animation
                       .onChange(of: isJumped) { newValue in
                           if newValue {
                               scheduleReverse() // Schedule a reversal after animation completes
                           }
                       }
        
    }
    
    // Schedule a reversal after a delay
        func scheduleReverse() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { // Adjust delay to allow animation completion
                withAnimation {
                    isJumped = false // Reverse the animation
                }
            }
        }
}

#Preview {
    ContentView()
}
