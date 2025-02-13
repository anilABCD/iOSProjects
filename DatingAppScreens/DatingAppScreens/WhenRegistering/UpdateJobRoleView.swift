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
    @State   var selectedJobRole = "Senior Level"  // Default job role stored
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
            
            
            // Job Role Picker similar to Smoking Picker example
//                       HStack {
//                           Image(systemName: "briefcase.fill")
//                               .foregroundColor(themeManager.currentTheme.buttonColor)
//                                              .padding(.leading)
//                   
//                         
//                               // **Button that Opens Picker**
//                               Button(action: { isPickerPresented.toggle()
//                                   
//                                   isPickerPresented2 = false
//                                
//                               }) {
//                                   HStack {
//                                       Text(selectedJobRole)
//                                           .font(.system(size: 17))
//                                           .foregroundColor(themeManager.currentTheme.primaryColor)
//                                           .multilineTextAlignment(.center) // Align text properly
//                                           .fixedSize(horizontal: false, vertical: true) // Enable multiline
//                                       
//                                       VStack(spacing: 2) { // Small spacing between arrows
//                                                  Image(systemName: "chevron.up")
//                                                      .font(.system(size: 10)) // Adjust size
//                                                      .foregroundColor(themeManager.currentTheme.primaryColor)
//
//                                                  Image(systemName: "chevron.down")
//                                                      .font(.system(size: 10)) // Adjust size
//                                                      .foregroundColor(themeManager.currentTheme.primaryColor)
//                                              }
//                                   }
//                                   .padding()
//                                   .background(themeManager.currentTheme.backgroundColor)
//                                    
//                               
//                               
//                           }
//                           .padding()
//                          
//                          
////                           Picker("", selection: $selectedJobRole) {
////                               ForEach(jobRoles, id: \.self) { role in
////                                   Text(role).tag(role)
////                               }
////                           }
////                           .pickerStyle(MenuPickerStyle())
////                           .padding(.horizontal)
////                           .accentColor(themeManager.currentTheme.primaryColor)
//                       }
         
            
           
            
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
                                .foregroundColor(themeManager.currentTheme.primaryColor)
                                .multilineTextAlignment(.center) // Align text properly
                                .fixedSize(horizontal: false, vertical: true) // Enable multiline
                            
                            VStack(spacing: 2) { // Small spacing between arrows
                                       Image(systemName: "chevron.up")
                                           .font(.system(size: 10)) // Adjust size
                                           .foregroundColor(themeManager.currentTheme.primaryColor)

                                       Image(systemName: "chevron.down")
                                           .font(.system(size: 10)) // Adjust size
                                           .foregroundColor(themeManager.currentTheme.primaryColor)
                                   }
                        }
                        .padding()
                        .background(themeManager.currentTheme.backgroundColor)
                         
                    
                    
                }
               
               
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
                Button( showNextButton ? "Next" : "Submit" , action: {
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
                           CustomPopoverPicker3(
                                       title: "Select Job Role",
                                       isPickerPresented: $isPickerPresented,
                                       selectedJobRole: $selectedJobRole,
                                       jobRoles: jobRoles
               
                                   ) .background(TransparentBackground()) // Add this to sheet content
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.9)])  // Fixed 300pt height
                            .presentationDragIndicator(.visible) // Optional indicator
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

 
struct CustomPickerView: View {
    @State private var isPickerPresented = false
    @State private var selectedJobRole = "Designer"
    let jobRoles = ["Designer", "Developer", "Manager", "Product Owner"]

    var body: some View {
        VStack {
            // **Picker Button**
            Button(action: { isPickerPresented.toggle() }) {
                HStack {
                    Text(selectedJobRole)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    Image(systemName: "chevron.down") // Dropdown icon
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.cornerRadius(10)) // Button background
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
            }
            
            // **Custom Popover Picker**
            if isPickerPresented {
                VStack {
                    Text("Select Job Role")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.white)
                    
                    ForEach(jobRoles, id: \.self) { role in
                        Button(action: {
                            selectedJobRole = role
                            isPickerPresented.toggle()
                        }) {
                            Text(role)
                                .font(.system(size: 18, weight: .medium))
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.2).cornerRadius(8)) // List item background
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                    }

                    Button("Close") {
                        isPickerPresented = false
                    }
                    .padding()
                    .background(Color.red.cornerRadius(10))
                    .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 300)
                .background(Color.black.opacity(0.8).cornerRadius(15))
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .transition(.move(edge: .bottom))
                .animation(.spring(), value: isPickerPresented)
            }
        }
        .padding()
    }
}

 
struct FloatingCustomPicker: View {
    @State private var isPickerPresented = false
    @State private var selectedJobRole = "Designer"
    let jobRoles = ["Designer", "Developer", "Manager", "Product Owner"]

    var body: some View {
        ZStack {
            // Main Content
            VStack {
                Button(action: { isPickerPresented.toggle() }) {
                    HStack {
                        Text(selectedJobRole)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down") // Dropdown icon
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue.cornerRadius(10)) // Button background
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                }
            }
            .padding()

            // Floating Picker Overlay
            if isPickerPresented {
                ZStack {
                    // **Background Dim (Tap to Dismiss)**
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            isPickerPresented = false
                        }

                    // **Floating Picker**
                    VStack {
                        Text("Select Job Role")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.white)

                        ForEach(jobRoles, id: \.self) { role in
                            Button(action: {
                                selectedJobRole = role
                                isPickerPresented = false
                            }) {
                                Text(role)
                                    .font(.system(size: 18, weight: .medium))
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.white.opacity(0.2).cornerRadius(8)) // List item background
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal)
                        }

                        Button("Close") {
                            isPickerPresented = false
                        }
                        .padding()
                        .background(Color.red.cornerRadius(10))
                        .foregroundColor(.white)
                    }
                    .padding()
                    .frame(width: 300)
                    .background(Color.black.opacity(0.9).cornerRadius(15))
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .transition(.scale)
                    .animation(.spring(), value: isPickerPresented)
                }
            }
        }
    }
}
 
struct CustomPopoverPicker: View {
    @State private var isPickerPresented = false
    @State private var selectedJobRole = "Designer"
    let jobRoles = ["Designer", "Developer", "Manager", "Product Owner"]

    var body: some View {
        ZStack {
            VStack {
                // **Button that opens the popover**
                Button(action: { isPickerPresented.toggle() }) {
                    HStack {
                        Text(selectedJobRole)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down") // Dropdown icon
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue.cornerRadius(10)) // Button background
                }
            }
            .padding()

            // **Floating Popover**
            if isPickerPresented {
                VStack {
                    VStack(spacing: 8) {
                        ForEach(jobRoles, id: \.self) { role in
                            Button(action: {
                                selectedJobRole = role
                                isPickerPresented = false
                            }) {
                                Text(role)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding()
                                    .background(Color.white.opacity(0.1).cornerRadius(8))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.9).cornerRadius(12))
                    .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                    .frame(width: 250)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                    .transition(.scale)
                    .animation(.spring(), value: isPickerPresented)
                }
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.4) // Adjust for positioning
                
            }
        }
        .onTapGesture {
            isPickerPresented = false
        }
    }
}

 
struct CustomPopoverPicker2 : View {
    @State private var isPickerPresented = false
    @State private var selectedJobRole = "Designer"
    let jobRoles = ["Designer", "Developer", "Manager", "Product Owner", "QA Engineer", "Business Analyst", "Scrum Master", "HR", "Marketing", "Support", "Intern"] // Add more for scrolling

    var body: some View {
        ZStack {
            VStack {
                // **Picker Button (Does Not Move)**
                Button(action: { isPickerPresented.toggle() }) {
                    HStack {
                        Text(selectedJobRole)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: "chevron.down") // Dropdown icon
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.blue.cornerRadius(10)) // Button background
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            }
            .padding()

            // **Floating Popover (Appears Near Button)**
            if isPickerPresented {
                VStack {
                    Text("Select Job Role")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.top)

                    ScrollView {
                        VStack(spacing: 5) {
                            ForEach(jobRoles, id: \.self) { role in
                                Button(action: {
                                    selectedJobRole = role
                                    isPickerPresented = false
                                }) {
                                    Text(role)
                                        .font(.system(size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .background(Color.white.opacity(0.1).cornerRadius(8))
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(maxHeight: 200) // **Scrollable Limit**
                    
                    Button("Close") {
                        isPickerPresented = false
                    }
                    .padding()
                    .background(Color.red.cornerRadius(10))
                    .foregroundColor(.white)
                }
                .frame(width: 260)
                .background(Color.black.opacity(0.9).cornerRadius(12))
                .shadow(color: .black.opacity(0.4), radius: 10, x: 0, y: 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .transition(.scale)
                .animation(.spring(), value: isPickerPresented)
                .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height * 0.4) // **Fixed Positioning**
            }
        }
        .onTapGesture {
            isPickerPresented = false
        }
    }
}


struct CustomPopoverPicker3: View {
    var title: String
    @Binding var isPickerPresented: Bool
    @Binding var selectedJobRole: String
    var jobRoles: [String] = []
    @EnvironmentObject private var themeManager: ThemeManager
    
    // Search functionality
    @State private var searchText = ""
    
    var filteredRoles: [String] {
        guard !searchText.isEmpty else { return jobRoles }
        return jobRoles.filter { $0.localizedCaseInsensitiveContains(searchText) }
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
                    HStack {
                        Text(title)
                            .font(.system(.title3, design: .rounded, weight: .semibold))
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
                                    Button {
                                        searchText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .padding(.trailing, 15)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        )
                    
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
                            
                            Color.clear.frame(height: 100)
                        }
                        .onAppear {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                
                                withAnimation {
                                    proxy.scrollTo(selectedJobRole, anchor: .center)
                                }
                            }
                        }
                    }
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
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                )
                .frame(
                    width: UIScreen.main.bounds.width * 0.8,
                    height: UIScreen.main.bounds.height * 0.9
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
                selectedJobRole = role
                isPickerPresented = false
            }
        } label: {
            HStack(spacing: 15) {
                // Selection indicator
                ZStack {
                    Circle()
                        .strokeBorder(themeManager.currentTheme.primaryColor, lineWidth: 2)
                    
                    if selectedJobRole == role {
                        Circle()
                            .fill(themeManager.currentTheme.primaryColor)
                            .padding(4)
                    }
                }
                .frame(width: 22, height: 22)
                
                Text(role)
                    .font(.system(.body, design: .rounded))
                    .foregroundColor(themeManager.currentTheme.primaryColor)
                
                Spacer()
                
                if selectedJobRole == role {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(themeManager.currentTheme.primaryColor)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(themeManager.currentTheme.buttonSecondaryColor.opacity(0.2))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(ScaleButtonStyle())
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

struct TransparentSheetContent: View {
    @Environment(\.dismiss) var dismiss
    
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
