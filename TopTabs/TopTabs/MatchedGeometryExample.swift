//
//  MatchedGeometryExample.swift
//  TopTabs
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//

import SwiftUI

struct MatchedGeometryExample: View {
    @Namespace private var animationNamespace
    @State private var isExpanded = false

    var body: some View {
        VStack {
            if isExpanded {
                ExpandedView(animationNamespace: animationNamespace, isExpanded: $isExpanded)
            } else {
                CollapsedView(animationNamespace: animationNamespace, isExpanded: $isExpanded)
            }
        }
        .animation(.spring(), value: isExpanded)
    }
}

struct CollapsedView: View {
    var animationNamespace: Namespace.ID
    @Binding var isExpanded: Bool

    var body: some View {
        VStack {
            Spacer()
            VStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.blue)
                    .matchedGeometryEffect(id: "card", in: animationNamespace)
                    .frame(height: 150)
                    .overlay(Text("Tap to Expand").foregroundColor(.white).bold())
                    .onTapGesture {
                        withAnimation {
                            isExpanded.toggle()
                        }
                    }
                
                Button("Expand") {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }
                .padding(.top, 10)
            }
            .padding()
        }
    }
}

struct ExpandedView: View {
    var animationNamespace: Namespace.ID
    @Binding var isExpanded: Bool

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .matchedGeometryEffect(id: "card", in: animationNamespace)
                .frame(height: 300)
                .overlay(Text("Tap to Collapse").foregroundColor(.white).bold())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

            Button("Collapse") {
                withAnimation {
                    isExpanded.toggle()
                }
            } .matchedGeometryEffect(id: "card2", in: animationNamespace)
            .padding(.top, 10)
            
            
        }
        .padding()
    }
}

struct MatchedGeometryExample_Previews: PreviewProvider {
    static var previews: some View {
        MatchedGeometryExample()
    }
}
