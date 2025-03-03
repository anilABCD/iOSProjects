//
//  MultiSelectPicker 2.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 02/03/25.
//


import SwiftUI

struct MultiSelectPickerTwo: View {
    let allOptions: [String]
    @State private var selectedOptions: Set<String> = Set<String>()
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
                
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 10) {
                    ForEach(filteredOptions, id: \ .self) { option in
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
                        .padding()
                        .background(selectedOptions.contains(option) ? Color.blue.opacity(0.3) : Color.blue.opacity(0.1))
                        .cornerRadius(10)
                        .onTapGesture {
                            toggleSelection(for: option)
                        }
                    }
                }
                .padding()
            }
            
            if !selectedOptions.isEmpty {
                VStack(alignment: .leading) {
                    Text("Selected:")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(Array(selectedOptions), id: \ .self) { (item: String) in
                                HStack {
                                    Text(item)
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .onTapGesture {
                                            DispatchQueue.main.async {
                                                    withAnimation {
                                                        var newSelection = selectedOptions
                                                                newSelection.remove(item)
                                                                selectedOptions = newSelection
                                                    }
                                                }
                                        }
                                }.id(item) // Forces SwiftUI to refresh the view
                                .padding(8)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Spacer()
            
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Text("Done")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
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

struct MultiSelectPickerTwo_Previews: PreviewProvider {
    static var previews: some View {
        MultiSelectPickerTwo(allOptions: ["Apple", "Banana", "Cherry", "Date", "Elderberry", "Fig", "Grape"])
    }
}
