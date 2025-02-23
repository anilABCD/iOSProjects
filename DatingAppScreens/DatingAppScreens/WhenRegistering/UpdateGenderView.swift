//
//  UpdateGenderView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 23/02/25.
//


import SwiftUI

import SwiftUI

struct UpdateGenderView: View {
    
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var tokenManger: TokenManager
    
    @State private var responseMessage = ""
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var isFirstTimeUpdating = false;
    
    @State var showAlert : Bool = false;
    
    @State private var selectedGender: String? = nil
    
    var showNextButton : Bool = false
    
    func updateGender() async {
        
        guard let selectedGender = selectedGender as? String else {
            print("Please select a gender")
            
            showAlert = true
            return
        }
        
        if ( selectedGender.isEmpty ){
            
            print("Please select a gender")
            
            showAlert = true
            return
        }
        
        
        // Create the request payload
        let payload: [String: String] = [
            "gender": selectedGender
        ]
        
        do {
            // Create the request using the provided createURLRequest function
            let request = try await createURLRequest(method: "POST", baseURL: "\(tokenManger.localhost)/profiles/update-gender", accessToken: tokenManger.accessToken, data: payload, parameters: nil)

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
                            responseMessage = "Job role updated successfully: \(decodedResponse["gender"] ?? "")"
                            
                            tokenManger.gender = selectedGender;
                            
                            
                            
                            
                            if ( !isFirstTimeUpdating && showNextButton == false) {
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
    
    var body: some View {
        VStack {
            
            Spacer()
            // Display selected gender image on top
            if let gender = selectedGender  {
                
                if !gender.isEmpty {
                    Image(gender == "male" ? "male1" : "female1")
                        .resizable()
                        .frame(width: 150, height: 150)
                        .padding()
                    
                    Text(gender == "male" ? "Male" : "Female").modifier(ThemedTextModifier())
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                else{
                    GenderEmptySpaceSpaceHolderView()
                }
            }
            else{
                GenderEmptySpaceSpaceHolderView()
            }
            
            Spacer()
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Image("male")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(selectedGender == "male" ? Color.blue.opacity(0.3) : Color.clear)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedGender = "male"
                            }
                        
                        Text("Male").modifier(ThemedTextModifier())
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                    }
                    
                    VStack {
                        Image("female")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .padding()
                            .background(selectedGender == "female" ? Color.pink.opacity(0.3) : Color.clear)
                            .cornerRadius(10)
                            .onTapGesture {
                                selectedGender = "female"
                            }
                        
                        Text("Female").modifier(ThemedTextModifier())
                                                    .font(.subheadline)
                                                    .foregroundColor(.primary)
                    }
                }
            }
           
            
            Button(showNextButton ? "Next" : Constants.Strings.submitButtonTitle , action: {
             
                Task {
                    await  self.updateGender()
                    
                }
            }).buttonStyle(ThemedButtonStyle()).padding(.horizontal)
            
        }  .alert(isPresented: $showAlert) {
            Alert(title: Text("Required"), message: Text("Please Select Gender"), dismissButton: .default(Text("OK")))
        }
        .padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline).background( themeManager.currentTheme.backgroundColor)
            .onAppear(){
            // Assuming tokenManager.technologies is a string containing comma-separated values
            if tokenManger.jobRole == "" {
                isFirstTimeUpdating = true;
            }
            if tokenManger.jobRole != "" {
                selectedGender = tokenManger.gender;
//                selectedGender = "female"
            }
        } // Keeps the back button // Conditionally add padding.navigationBarTitle("", displayMode: .inline) // Keeps the back button
    }
}

#if DEBUG
// Preview code for Xcode
struct MGenderView_Previews: PreviewProvider {
    static var previews: some View {
        UpdateGenderView().environmentObject(ThemeManager()).environmentObject(TokenManager())
    }
}
#endif


struct GenderEmptySpaceSpaceHolderView: View {
    
    var body: some View {
        Color.clear.frame(width: 150, height: 150).padding()
        Text(" ")
                              .font(.headline)
                              .foregroundColor(.primary)
    }
}
