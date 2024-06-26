//
//  ContentView.swift
//  Timer
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import SwiftUI

struct ContentView: View {
    
    @State var timeRemaning : TimeInterval = 10;
    
    @State var timer : Timer?;
    
    @State var isRunning : Bool = false;
    
    var body: some View {
      
        VStack(alignment:.center) {
            
            ZStack {
                
                
                Circle().stroke(Color.black, lineWidth: 25).opacity(0.3).padding(25)
                
                Circle().stroke( style:  StrokeStyle(lineWidth: 25 ,  lineCap: .round, lineJoin: .round, dash: [CGFloat( 0.2),CGFloat(0.2)])).trim(from:0 , to :
                                                                                                                CGFloat( ( 1 - ( timeRemaning / 10 ) ) )
                
                )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut, value: timeRemaning).padding(25)
    
                Circle() // Outer circle for the stroke
                    .stroke(Color.white, lineWidth: 0) .fill(.white).padding(35)
                                 
                Text(timeRemaning, format: .number)
            }
            
            VStack {
                
                Button("Start"){
                    timeRemaning = 10
                    StartTimer();
                }
            }
            .padding()
        }
    }
    
    
    private func StartTimer () {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true ) { _ in
            
            if(timeRemaning > 0 ){
                timeRemaning -= 1;
                
            }
            else{
                StopTimer()
            }
        }
    }
    
    private func StopTimer () {
     
        timeRemaning = 0;
        timer?.invalidate();
        
    }
        
}



#Preview {
    ContentView()
}
