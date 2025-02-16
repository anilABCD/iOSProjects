//
//  UpdateJobRoleView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 25/12/24.
//

import SwiftUI

struct UpdateJobRoleView: View {
    // List of job roles
    let jobRoles = [
        "Intern", "Junior Level", "Mid Level", "Senior Level", "Lead Level",
        "Manager", "Director", "Vice President", "Chief Technology Officer (CTO)",
        "Chief Information Officer (CIO)", "Chief Product Officer (CPO)",
        "Chief Operating Officer (COO)", "Chief Executive Officer (CEO)"
    ]
    @EnvironmentObject private var tokenManger : TokenManager
   
    var showNextButton : Bool = false;
    @State  var isPickerPresented : Bool = false
    @State  var isPickerPresented1 : Bool = false
    @State  var isPickerPresented2 : Bool = false
    @State  var isPickerPresented3 : Bool = false
    // State variables
    @State  var selectedJobRole = "Senior Level"  // Default job role stored
   
    // multiselect example : 
//    @State var selectedJobRoles : [String] = [ "Select Job Role"]
    
    @State private var isUpdating = false
    @State private var responseMessage = ""
    
    @State var isFirstTimeUpdatingBio = false;
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    var body: some View {
        VStack {
            
        
            HStack {
                
                Text("Job Role")
                    .font(.title) // Use .subheadline or .callout for smaller text
                    .modifier(ThemedTextModifier())
             
                Spacer();
                
            }
                       
            HStack {
                Image(systemName: "briefcase.fill")
                    .foregroundColor(themeManager.currentTheme.buttonColor)
                                   .padding(.leading)
        
              
                    // **Button that Opens Picker**
                    Button(action: { isPickerPresented.toggle()
                          
                    }) {
                        HStack {
                            Text(selectedJobRole)
                                .font(.system(size: 17))
                                .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                .multilineTextAlignment(.center) // Align text properly
                                .fixedSize(horizontal: false, vertical: true) // Enable multiline
                            
                            VStack(spacing: 2) { // Small spacing between arrows
                                       Image(systemName: "chevron.up")
                                           .font(.system(size: 10)) // Adjust size
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor)

                                       Image(systemName: "chevron.down")
                                           .font(.system(size: 10)) // Adjust size
                                           .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                                   }
                        }
                        .padding()
                        .background(themeManager.currentTheme.backgroundColor)
                         
                    
                    
                }
//                
//
                   // multi select example .
//                // **Button that Opens Picker**
//                Button(action: { isPickerPresented.toggle()
//                      
//                }) {
//                    HStack {
//                        Text(selectedJobRoles.joined(separator: ", "))
//                            .font(.system(size: 17))
//                            .foregroundColor(themeManager.currentTheme.primaryColor)
//                            .multilineTextAlignment(.center) // Align text properly
//                            .fixedSize(horizontal: false, vertical: true) // Enable multiline
//                        
//                        VStack(spacing: 2) { // Small spacing between arrows
//                                   Image(systemName: "chevron.up")
//                                       .font(.system(size: 10)) // Adjust size
//                                       .foregroundColor(themeManager.currentTheme.primaryColor)
//
//                                   Image(systemName: "chevron.down")
//                                       .font(.system(size: 10)) // Adjust size
//                                       .foregroundColor(themeManager.currentTheme.primaryColor)
//                               }
//                    }
//                    .padding()
//                    .background(themeManager.currentTheme.backgroundColor)
//                     
//                
//                
//            }
               
               
//                           Picker("", selection: $selectedJobRole) {
//                               ForEach(jobRoles, id: \.self) { role in
//                                   Text(role).tag(role)
//                               }
//                           }
//                           .pickerStyle(MenuPickerStyle())
//                           .padding(.horizontal)
//                           .accentColor(themeManager.currentTheme.primaryColor)
            }
                       
            .frame(width:310)
                       .background(themeManager.currentTheme.backgroundColor)
                      
                        
                    
            
//            CustomPickerView()
//
//            FloatingCustomPicker()
            
          
              
//            // Picker to select job role
//            Picker("Select Job Role", selection: $selectedJobRole) {
//                ForEach(jobRoles, id: \.self) { role in
//                    Text(role).tag(role)
//                }
//            }
//            .pickerStyle(MenuPickerStyle())
//            .padding()

            
            // Response message
//            Text(responseMessage)
//                .foregroundColor(.green)
//                .padding()
            
            Spacer()

            HStack {
                // Button to update the job role
                Button( showNextButton ? "Next" : Constants.Strings.submitButtonTitle , action: {
                    Task {
                        await updateJobRole()
                    }
                }).buttonStyle(ThemedButtonStyle())
//                }) {
//                    Text( showNextButton ? "Next" : "Submit")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
                    
               
            }

           
           
        }.padding(.top).padding(.horizontal)
        .padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline).onAppear(){
            // Assuming tokenManager.technologies is a string containing comma-separated values
            if tokenManger.jobRole == "" {
                isFirstTimeUpdatingBio = true;
            }
            if tokenManger.jobRole != "" {
                selectedJobRole = tokenManger.jobRole;
            }
        }.background(themeManager.currentTheme.backgroundColor)
            .onTapGesture {
                isPickerPresented = false
            }
            
            .sheet(isPresented: $isPickerPresented ) {
                           CustomPopoverPickerSingleSelect(
                                       title: "Select Job Role",
                                       isPickerPresented: $isPickerPresented,
                                       selectedItem: $selectedJobRole,
                                       list: jobRoles
               
                                   )
                           .background(themeManager.currentTheme.backgroundColor)
//                           .background(TransparentBackground()) // Add this to sheet content
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.85)])  // Fixed 300pt height
                            .presentationDragIndicator(.visible) // Optional indicator
                
//                Multiselect example
//                CustomPopoverPickerMultiselect(
//                            title: "Select Job Role",
//                            isPickerPresented: $isPickerPresented,
//                            selectedItems: $selectedJobRoles,
//                            list: jobRoles ,
//                            isMultiselect: true ,
//                            defaultSelectText: "Select Job Role"
//    
//                        ) .background(TransparentBackground()) // Add this to sheet content
//         .presentationDetents([.height(UIScreen.main.bounds.height * 0.85)])  // Fixed 300pt height
//                 .presentationDragIndicator(.visible) // Optional indicator
//                
                
                    }
        
        
        
//            .overlay(
//                VStack {
//                    CustomPopoverPicker3(
//                        title: "Select Job Role",
//                        isPickerPresented: $isPickerPresented,
//                        selectedJobRole: $selectedJobRole,
//                        jobRoles: jobRoles
//                        
//                    )
//                    
//                    CustomPopoverPicker3(
//                        title: "Select Job Role",
//                        isPickerPresented: $isPickerPresented2,
//                        selectedJobRole: $selectedJobRole,
//                        jobRoles: jobRoles
//                        
//                    )
//                }
//                    )
    }

    func updateJobRole() async {
        // Create the request payload
        let payload: [String: String] = [
            "jobRole": selectedJobRole
        ]
        
        do {
            // Create the request using the provided createURLRequest function
            let request = try await createURLRequest(method: "POST", baseURL: "\(tokenManger.localhost)/profiles/update-jobrole", accessToken: tokenManger.accessToken, data: payload, parameters: nil)

            // Perform the network request asynchronously
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // Check the HTTP response status code
            if let httpResponse = response as? HTTPURLResponse {
                // Check if status code indicates success (2xx range)
                if httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 {
                    // Status code indicates success, now decode the response data
                   
                        do {
                            // Decode the response into a dictionary
                            let decodedResponse = try JSONDecoder().decode([String: String].self, from: data)
                            responseMessage = "Job role updated successfully: \(decodedResponse["jobRole"] ?? "")"
                            
                            tokenManger.jobRole = selectedJobRole;
                            
                            if ( !isFirstTimeUpdatingBio && showNextButton == false) {
                                presentationMode.wrappedValue.dismiss()
                            }
                            
                            tokenManger.nextButtonWhenRegistrationProcess = UUID()
                            
                        } catch {
                            responseMessage = "Failed to decode response: \(error.localizedDescription)"
                        }
                
                } else {
                    // Handle unsuccessful response status code
                    responseMessage = "Error: Received status code \(httpResponse.statusCode)"
                }
            }
        } catch {
            responseMessage = "Error: \(error.localizedDescription)"
        }
    }

}

struct UpdateJobRoleView_Previews: PreviewProvider {
  
    static var previews: some View {
        UpdateJobRoleView(showNextButton : true).environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}

struct CustomPopoverPickerSingleSelect: View {
    var title: String
    @Binding var isPickerPresented: Bool
    @Binding var selectedItem: String
    var list: [String] = []
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Search functionality
    @State private var searchText = ""
    
    var filteredRoles: [String] {
        guard !searchText.isEmpty else { return list }
        return list.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            // Semi-transparent overlay
            if isPickerPresented {
                Color.clear
                    .onTapGesture { isPickerPresented = false }
            }
            
            // Popover content
            if isPickerPresented {
                VStack(spacing: 0) {
                    // Header
                    
                    VStack {
                        HStack {
                            Text(title)
                                .font(.system(.title3, design: .rounded))
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                            
                            Spacer()
                            
                            Button {
                                isPickerPresented = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.title2)
                                    .foregroundColor(themeManager.currentTheme.primaryColor)
                            }
                        }
                        .padding()
                        
//                        // Search bar
//                        TextField("Search roles", text: $searchText)
//                            .padding(.horizontal, 40)
//                            .padding(.vertical, 12)
//                            .background(Color(.systemBackground))
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                            .overlay(
//                                HStack {
//                                    Image(systemName: "magnifyingglass")
//                                        .foregroundColor(.gray)
//                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
//                                        .padding(.leading, 20)
//                                    
//                                    if !searchText.isEmpty {
//                                        Button {
//                                            searchText = ""
//                                        } label: {
//                                            Image(systemName: "xmark.circle.fill")
//                                                .padding(.trailing, 15)
//                                                .foregroundColor(.gray)
//                                        }
//                                    }
//                                }
//                            )
                        
                        // Content list
                        ScrollViewReader { proxy in
                            ScrollView(showsIndicators: false) {
                                LazyVStack(spacing: 8) {
                                    ForEach(filteredRoles, id: \.self) { role in
                                        roleItem(role: role)
                                            .transition(.opacity.combined(with: .move(edge: .leading)))
                                    }
                                }
                                .padding()
                                
//                                Color.clear.frame(height: 10)
                            }
                            .onAppear {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    
                                    withAnimation {
                                        proxy.scrollTo(selectedItem, anchor: .center)
                                    }
                                }
                            }
                        }
                        
                        Spacer()
                        
//                        Button("Close"){
//                            isPickerPresented = false
//                        }
//                        .buttonStyle(ThemedButtonStyle())
                    }
                    .background(
                        themeManager.currentTheme.backgroundColor
                            .cornerRadius(20)
                            .shadow(
                                color: Color.black.opacity(0.1),
                                radius: 20,
                                x: 0,
                                y: 10
                            )
                    )
                    .padding()
                }
               
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .frame(
                    width: UIScreen.main.bounds.width ,
                    height: UIScreen.main.bounds.height * 0.85
                )
                .transition(
                    .asymmetric(
                        insertion: .opacity.combined(with: .scale(scale: 0.95)),
                        removal: .opacity.combined(with: .scale(scale: 0.95))
                    )
                )
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPickerPresented)
    }
    

    private func roleItem(role: String) -> some View {
        Button {
            withAnimation(.interactiveSpring()) {
                selectedItem = role
                isPickerPresented = false
            }
        } label: {
            
            VStack {
                HStack(spacing: 15) {
                    
                    Text(role)
                        .font(.system(.body, design: .rounded))
                        .foregroundColor(themeManager.currentTheme.navigationLinkColor)
                    Spacer()
                    // Selection indicator
                    ZStack {
                        Circle()
                            .strokeBorder(themeManager.currentTheme.navigationLinkColor, lineWidth: 2)
                        
                        if selectedItem == role {
                            Circle()
                                .fill(themeManager.currentTheme.navigationLinkColor)
                                .padding(4)
                        }
                    }
                    .frame(width: 22, height: 22)
                    
                    
                    //                if selectedJobRole == role {
                    //                    Image(systemName: "checkmark")
                    //                        .font(.system(size: 14, weight: .bold))
                    //                        .foregroundColor(themeManager.currentTheme.primaryColor)
                    //                }
                }
                Divider() // Separator line
            }
            .padding(.horizontal)
//            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.currentTheme.backgroundColor.opacity(0.2))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}



struct CustomPopoverPickerMultiselect : View {
    var title: String
    @Binding var isPickerPresented: Bool
    @Binding var selectedItems: [String] // Changed to array for multi-selection
    var list: [String] = []
    var isMultiselect: Bool // New flag for multi-selection
    var defaultSelectText : String
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var searchText = ""
    
    var filteredRoles: [String] {
        guard !searchText.isEmpty else { return list }
        return list.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        ZStack {
            if isPickerPresented {
                Color.clear.onTapGesture { isPickerPresented = false }
            }
            
            if isPickerPresented {
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            Text(title)
                                .font(.system(.title3, design: .rounded, weight: .semibold))
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                            
                            Spacer()
                            
                            Button { isPickerPresented = false } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .symbolRenderingMode(.hierarchical)
                                    .font(.title2)
                                    .foregroundColor(themeManager.currentTheme.primaryColor)
                            }
                        }
                        .padding()
                        
                        // Search bar
                        TextField("Search roles", text: $searchText)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Color(.systemBackground))
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .overlay(
                                HStack {
                                    Image(systemName: "magnifyingglass")
                                        .foregroundColor(.gray)
                                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                        .padding(.leading, 20)
                                    
                                    if !searchText.isEmpty {
                                        Button { searchText = "" } label: {
                                            Image(systemName: "xmark.circle.fill")
                                                .padding(.trailing, 15)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                            )
                        
                        // Content list
                        ScrollView(showsIndicators: false) {
                            LazyVStack(spacing: 8) {
                                ForEach(filteredRoles, id: \.self) { role in
                                    roleItem(role: role)
                                        .transition(.opacity.combined(with: .move(edge: .leading)))
                                    Divider() // Separator
                                }
                            }
                            .padding()
                        }
                        
                        Spacer()
                    }
                    .background(
                        themeManager.currentTheme.backgroundColor
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                    )
                    .padding()
                }
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.85)
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isPickerPresented)
    }
    
    // Role item selection logic
    @ViewBuilder
    private func roleItem(role: String) -> some View {
        HStack(spacing: 15) {
            Text(role)
                .font(.system(.body, design: .rounded))
                .foregroundColor(themeManager.currentTheme.navigationLinkColor)
            
            Spacer()
            
            // Selection indicator
            ZStack {
                Circle()
                    .strokeBorder(themeManager.currentTheme.primaryColor, lineWidth: 2)
                
                if selectedItems.contains(role) {
                    Circle()
                        .fill(themeManager.currentTheme.primaryColor)
                        .padding(4)
                }
            }
            .frame(width: 22, height: 22)
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle()) // Makes the whole row tappable
        .onTapGesture {
            if isMultiselect {
                if selectedItems.contains(role) {
                    selectedItems.removeAll { $0 == role }
                    
                   
                } else {
                    selectedItems.append(role)
                }
                
                if ( selectedItems.isEmpty){
                    selectedItems.append(defaultSelectText)
                }
                else{
                    selectedItems.removeAll { $0 == defaultSelectText}
                }
                
                
            } else {
                selectedItems = [role] // Single selection mode
                isPickerPresented = false // Close popover
            }
        }
    }
}




// Button press effect
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .opacity(configuration.isPressed ? 0.9 : 1)
            .animation(.interactiveSpring(), value: configuration.isPressed)
    }
}


//
//struct CustomPopoverPicker3 : View {
//    var title : String
//    
//    @Binding  var isPickerPresented : Bool
//    @Binding   var selectedJobRole : String
//    var jobRoles : [String] = []
//
//    @State private var buttonFrame: CGRect = .zero // Stores button's position
//    @State private var scrollToJob: String? = nil // Stores the job role to scroll to
//
//    @EnvironmentObject private var themeManager : ThemeManager
//    
//    var body: some View {
//     
//           
//             
//                    
//                    //                    // **Tap outside to dismiss**
//                    //                    Color.black.opacity(0.3)
//                    //                        .edgesIgnoringSafeArea(.all)
//                    //                        .onTapGesture { isPickerPresented = false }
//                    //
//                    // **Popover Content**
//        
//        if(isPickerPresented) {
//            
//            VStack {
//                
//            
//                
//                Text(title)
//                    .font(.headline)
//                    .foregroundColor(themeManager.currentTheme.primaryColor)
//                    .padding(.top)
//                    .padding(30)
//                
//                
//                ScrollViewReader { proxy in
//                    ScrollView ( showsIndicators: true )  {
//                        VStack(spacing: 5) {
//                            ForEach(jobRoles, id: \.self) { role in
//                                Button(action: {
//                                    selectedJobRole = role
//                                    
//                                    
//                                    
//                                    isPickerPresented = false
//                                }) {
//                                    
//                                    HStack {
//                                       
//                                        Text(role)
//                                            .font(.system(size: 16))
//                                        
//                                        Spacer()
//                                        
//                                        if selectedJobRole == role {
//                                            // Filled Circle
//                                            Circle()
//                                                .fill(.white)
//                                                .frame(width: 20, height: 20)
//                                        }
//                                        else{
//                                            // Unfilled Circle (Outline)
//                                            Circle()
//                                                .stroke(.white, lineWidth: 2)
//                                                .frame(width: 20, height: 20)
//                                            
//                                        }
//                                        
//                                      
//                                    }
//                                    
//                                    .foregroundColor(.white)
//                                    .padding()
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                                    .background(themeManager.currentTheme.buttonSecondaryColor.cornerRadius(8))
//                                    
//                                }.id(role) // Assign an ID to each job role
//                                
//                            }
//                        }
//                        .padding()
//                    }
//                    .frame( maxWidth: .infinity , maxHeight: .infinity ) // Scrollable Limit
//                    .onAppear {
//                          
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                                withAnimation(.easeInOut(duration: 0.5)) { // **Smooth scrolling animation**
//                                    proxy.scrollTo(selectedJobRole, anchor: .center)
//                                }
//                            }
//                        
//                    }
//                    
//                }
//                Button("Close") {
//                    isPickerPresented = false
//                }
//                .buttonStyle(ThemedButtonStyle())
//                .padding()
//                
//            }.onAppear {
//                UIScrollView.appearance().indicatorStyle = .white  // **Set Scroll Indicator to White**
//                scrollToJob = selectedJobRole
//            }
//             
//            .background(themeManager.currentTheme.backgroundColor.cornerRadius(12))
//            .shadow(color: themeManager.currentTheme.backgroundColor.opacity(0.4), radius: 10, x: 0, y: 5)
//            .overlay(
//                RoundedRectangle(cornerRadius: 12)
//                    .stroke(themeManager.currentTheme.primaryColor.opacity(0.2), lineWidth: 1)
//            )
//            .transition(.scale)
//            .animation(.spring(), value: isPickerPresented)
//            
//            .frame(width : UIScreen.main.bounds.width * 0.9 )
//            .background(TransparentBackground()) // Apply transparent background
//                .ignoresSafeArea() // Fill entire available space
//                    
//        }
//               
//    }
//}
// 
//

struct TransparentBackground: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return TransparentBackgroundController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    private class TransparentBackgroundController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = .clear
        }
        
        override func willMove(toParent parent: UIViewController?) {
            super.willMove(toParent: parent)
            parent?.view?.backgroundColor = .clear
            parent?.presentationController?.containerView?.backgroundColor = .clear
        }
    }
}




// Example for transparent background in sheet .
struct TransparentSheetContent: View {
    @Environment(\.dismiss) var dismiss

    // to apply in another screen .
    //    .sheet( isPresented : $isPickerPresented){
    //        TransparentSheetContent()
    //            .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])  // Fixed 300pt height
    //                    .presentationDragIndicator(.visible) // Optional indicator
    //    }

    var body: some View {
        VStack(spacing: 20) {
            
            VStack {
                Text("Transparent Sheet")
                    .font(.title)
                    .foregroundColor(.white)
            }
            
            Button("Dismiss") {
                dismiss()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(TransparentBackground()) // Apply transparent background
        .ignoresSafeArea() // Fill entire available space
    }
}



