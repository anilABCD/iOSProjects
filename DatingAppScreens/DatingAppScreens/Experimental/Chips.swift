
import SwiftUI

struct Chip: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var isSelected: Bool = false

    static func == (lhs: Chip, rhs: Chip) -> Bool {
        return lhs.id == rhs.id && lhs.isSelected == rhs.isSelected
    }
}

struct ChipView: View {
    @Binding var chip: Chip

    var body: some View {
        Text(chip.name)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(chip.isSelected ? Color.blue : Color.blue.opacity(0.2))
            .cornerRadius(20)
            .foregroundColor(chip.isSelected ? Color.white : Color.blue)
//            .fontWeight(.semibold)
//            .foregroundColor(chip.isSelected ? .white : .white)
//            .padding(.vertical, 10)
//            .padding(.horizontal)
//            .background(chip.isSelected ? Color.blue : Color.gray)
//            .clipShape(Capsule())
//                        .overlay(Capsule().stroke(Color.white, lineWidth: 1))
//                        .lineLimit(1)
            .onTapGesture {
                
                print("is tap clicked \(chip.isSelected) \(chip.name)")
                
                
                chip.isSelected.toggle()
            }
    }
}

struct ChipsView: View {
    @Binding var chips: [Chip]
    @State private var containerHeight: CGFloat = 0
    var body: some View {
        GeometryReader { geometry in
            VStack (alignment: .center) {
                       self.generateChipsLayout(in: geometry)
                           .background(GeometryReader { innerGeometry -> Color in
                               DispatchQueue.main.async {
                                   self.containerHeight = innerGeometry.size.height
                               }
                               return Color.clear
                           })
                   }
                   .frame(height: containerHeight )
               }
               .padding()
    }

    private func generateChipsLayout(in geometry: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach($chips.indices, id: \.self) { index in
                ChipView(chip: $chips[index])
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > geometry.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if index == self.chips.count - 1 {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { _ in
                        let result = height
                        if index == self.chips.count - 1 {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}



struct abcView: View {
    @State private var chips = [
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
        VStack (alignment: .leading){
            Text("Above the chips")
                .font(.largeTitle)
                .padding()
            
            ScrollView {
               
                ChipsView(chips: $chips)
               
            }.frame(maxHeight:200)
            
            Text("Above the chips")
                .font(.largeTitle)
                .padding()
          
        }.frame( maxHeight:.infinity, alignment: .topLeading)
    }
}

struct  abcView_Previews: PreviewProvider {
  
    static var previews: some View {
        abcView()
    }
}



