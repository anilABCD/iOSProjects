//
//  MultiSelectPicker.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 02/03/25.
//


import SwiftUI


struct MultiSelectPicker: View {
    let allOptions: [String]
    @State private var selectedOptions: Set<String> = []
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var filteredOptions: [String] {
        if searchText.isEmpty {
            return allOptions
        } else {
            return allOptions.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
                Spacer()
                Text("Select Items")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Button(action: toggleSelectAll) {
                    Text(selectedOptions.count == allOptions.count ? "Deselect All" : "Select All")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .background(Color.blue)
            
            TextField("Search...", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
            List(filteredOptions, id: \ .self) { option in
                HStack {
                    Text(option)
                    Spacer()
                    if selectedOptions.contains(option) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.blue)
                            .transition(.scale)
                    } else {
                        Image(systemName: "circle")
                            .foregroundColor(.gray)
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    toggleSelection(for: option)
                }
            }
            
            if !selectedOptions.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected:")
                        .font(.headline)
                        .foregroundColor(.blue)
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(selectedOptions), id: \ .self) { item in
                                Text(item)
                                    .padding(8)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
    
    private func toggleSelection(for option: String) {
        withAnimation {
            if selectedOptions.contains(option) {
                selectedOptions.remove(option)
            } else {
                selectedOptions.insert(option)
            }
        }
    }
    
    private func toggleSelectAll() {
        withAnimation {
            if selectedOptions.count == allOptions.count {
                selectedOptions.removeAll()
            } else {
                selectedOptions = Set(allOptions)
            }
        }
    }
}

struct TempPickerExample: View {
    @State private var isPickerPresented = false

    var body: some View {
        VStack {
            Button("Open Multi-Select Picker") {
                isPickerPresented.toggle()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .sheet(isPresented: $isPickerPresented) {
            MultiSelectPicker(allOptions: ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"])
        }
    }
}

struct MultiSelectPicker_Previews: PreviewProvider {
    static var previews: some View {
        TempPickerExample()
    }
}
