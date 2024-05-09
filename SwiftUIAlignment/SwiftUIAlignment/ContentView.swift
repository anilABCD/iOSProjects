//
//  ContentView.swift
//  SwiftUIAlignment
//
//  Created by Anil Kumar Potlapally on 09/05/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack ( alignment:.leading ) {
            HStack ( ) {
               
                Text("Third")
            }
            .frame(maxWidth:.infinity , alignment: .leading)
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        
        VStack ( alignment:.center ) {
            HStack ( ) {
               
                Text("Third")
            }
            .frame(maxWidth:.infinity , alignment: .center)
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack ( ) {
            HStack ( ) {
               
                Text("Third")
            }
           
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
            
           
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .topLeading) // Content aligns to the left within the frame
        .background(Color.brown) // For visibility, we set a background color
        
        
        VStack {
            HStack ( ) {
               
                Text("Third")
            }
          
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
            
           
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .bottomTrailing) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        .border(Color.green)
        

        VStack (  ) {
            HStack ( ) {
               
                Text("Third")
            }
           
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity, alignment: .center) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
            HStack ( ) {
               
                Text("Third")
            }
        
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .center) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color

        VStack{
            HStack ( ) {
               
                Text("Third")
            }
        
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .topTrailing) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color

        VStack{
            HStack ( ) {
               
                Text("Third")
            }
        
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .bottomLeading) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color

        
        VStack{
            HStack ( ) {
               
                Text("Third")
            }
        
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .centerLastTextBaseline) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
            HStack ( ) {
               
                Text("Third")
            }
        
            HStack{
                Text("3")
                Text("2")
                Text("1")
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .centerFirstTextBaseline ) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
          
            HStack{
                Text("3").frame(maxWidth:.infinity , alignment: .leading )
                Text("2")
                Text("1")
                Spacer()
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .leading ) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
          
            HStack{
                Text("3").frame(maxWidth:.infinity , alignment: .leading )
                Text("2").frame(maxWidth:.infinity , alignment: .leading )
                Text("1")
                Spacer()
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .leading ) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
          
            HStack{
                Text("3").frame(maxWidth:.infinity , alignment: .leading )
                Text("2").frame(maxWidth:.infinity , alignment: .leading )
                Text("1").frame(maxWidth:.infinity , alignment: .leading )
                Spacer()
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .leading ) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
        
        VStack{
          
            HStack{
                Text("3").frame(maxWidth:.infinity , alignment: .leading )
                Text("2").frame(maxWidth:.infinity , alignment: .leading )
                HStack {
                    Text("1").frame(maxWidth:.infinity , alignment: .leading )
                    Text("4").frame(maxWidth:.infinity , alignment: .leading )
                }
               
                Spacer()
            }
          
        }
        .frame(maxWidth: .infinity , maxHeight: .infinity, alignment: .leading ) // Content aligns to the left within the frame
        .background(Color.yellow) // For visibility, we set a background color
    }
}

#Preview {
    ContentView()
}
