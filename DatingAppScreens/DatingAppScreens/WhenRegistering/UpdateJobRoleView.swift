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
    
    // State variables
    @State private var selectedJobRole = "Junior Level"  // Default job role stored
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
                
            }.padding()
            
            
            // Job Role Picker similar to Smoking Picker example
                       HStack {
                           Image(systemName: "briefcase.fill")
                               .foregroundColor(themeManager.currentTheme.backgroundColor)
                                              .padding(.leading)
                           
                           Picker("", selection: $selectedJobRole) {
                               ForEach(jobRoles, id: \.self) { role in
                                   Text(role).tag(role)
                               }
                           }
                           .pickerStyle(MenuPickerStyle())
                           .padding(.horizontal)
                       }
                       .padding(.vertical, 8)
                       .background(Color(.systemGray6))  // Background color similar to the provided example
                       .cornerRadius(8)  // Corner radius for rounded edges

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
        UpdateJobRoleView(showNextButton : true).environmentObject(TokenManager())
    }
}
