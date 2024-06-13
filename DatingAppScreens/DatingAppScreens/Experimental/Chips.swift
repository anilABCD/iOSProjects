////
////  Chips.swift
////  DatingAppScreens
////
////  Created by Anil Kumar Potlapally on 13/06/24.
////
//
//import SwiftUI
//import Foundation
//
//struct Chip: Identifiable {
//    let id = UUID()
//    var text: String
//}
//
//import SwiftUI
//
//struct ChipView: View {
//    var chip: Chip
//
//    var body: some View {
//        Text(chip.text)
//            .padding(.horizontal, 12)
//            .padding(.vertical, 8)
//            .background(Color.blue.opacity(0.2))
//            .cornerRadius(20)
//            .foregroundColor(.blue)
//    }
//}
//
//struct ChipsView: View {
//    let chips: [[Chip]] = [[ Chip(text: "Hello") , Chip(text: "world") ]];
//    
//    var maxLenght = 0;
//
//    var body: some View {
//        
//        VStack {
//         
// 
//            ForEach(chips.indices, id: \.self) { index in
//                
//                HStack {
//                    
//                    ForEach(chips[index].indices, id: \.self) { chipIndex in
//                        
//                        GeometryReader { geometry in
//                            
//                            
//                            
//                            ChipView(chip: chips[index][chipIndex])
//                                .frame(width: geometry.size.width, height: geometry.size.height)
//                            
//                        } .frame(height: 50) // Set a fixed height for each chip's GeometryReader
//                    }
//                }
//            }
//            
//        }
//     
//        .padding()
//    }
//
//    private func createChipsLayout(in geometry: GeometryProxy) -> some View {
//        var width = CGFloat.zero
//        var height = CGFloat.zero
//
//        return ZStack(alignment: .topLeading) {
//           
//           
//        }
//    }
//
//    private func createChipView(for chip: Chip) -> some View {
//        ChipView(chip: chip)
//    }
//}
//
//struct  ChipsView_Previews: PreviewProvider {
//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
//       
//    static var previews: some View {
//        ChipsView()
//    }
//}
//
//


import SwiftUI

struct Chip: Identifiable, Equatable {
    let id = UUID()
    var name: String
    
    var isSelected: Bool = false

    static func == (lhs: Chip, rhs: Chip) -> Bool {
        return lhs.id == rhs.id
    }
}

struct ChipView: View {
    var chip: Chip

    var body: some View {
        Text(chip.name)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
//            .background(Color.blue.opacity(0.2))
            .cornerRadius(20)
//            .foregroundColor(.blue)
            .fontWeight(.semibold)
            .foregroundColor(chip.isSelected ? .white : .white)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(chip.isSelected ? Color.blue : Color.gray)
            .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                        .lineLimit(1)
    }
}


struct ChipsView: View {
    let chips: [Chip]

    var body: some View {
        GeometryReader { geometry in
            self.generateChipsLayout(in: geometry)
        }
        .padding()
    }

    private func generateChipsLayout(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(chips) { chip in
                ChipView(chip: chip)
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if chip == self.chips.last! {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        
                        print (width)
                        
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if chip == self.chips.last! {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}


struct abcView: View {
    let chips = [
        Chip(name: "Hello"),
        Chip(name: "world"),
        Chip(name: "SwiftUI"),
        Chip(name: "is"),
        Chip(name: "awesome"),
        Chip(name: "This"),
        Chip(name: "is"),
        Chip(name: "a"),
        Chip(name: "wrap"),
        Chip(name: "example")
    ]

    var body: some View {
        ScrollView {
            ChipsView(chips: chips)
        }
    }
}

struct  abcView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        abcView()
    }
}



