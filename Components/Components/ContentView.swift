//
//  ContentView.swift
//  Components
//
//  Created by Anil Kumar Potlapally on 09/02/25.
//

import SwiftUI


struct ContentView: View {
    var body: some View {
        ScrollView {
           
            TextInputTypeExample()
               
            GroupBoxExample()
            
            PageControlExample()
            
            SheetExample()
            
            TextExample()
            
            ColorPickerExample()
            
            CircularGaugeExample()
            
            LabeledGaugeExample()
            
            SimpleGaugeExample()
            VStack {
                ImageView()
            }.frame(maxHeight: 800)
            
            LabelExample()
            
            CustomLinkButton()
            
            LinkExample()
            
            ListIdentifiable()
            
            ListSeparatorHidden()
            
            ListWithoutIdentifiable()
            
            MenuExample()
            
            PickerExample()
            
            PopoverExample()
            
//            ScrollViewExample()
            
            SegmentedControlExample()
            
            SliderExample()
            
            SplitView()
            
            ThreeColumnSplitView()
            
            StepperExample()
            
            TabBarExample()
            
            TextFieldExample()
            
            ToggleExample()
            
            DisclosureGroupExample()
            
            AlertExample()
            
            ShareSheetExample()
            
            ActionSheetExample()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
