 
//
//  UpdateDrinkingView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 18/02/25.
//

//
//  UpdateSmokingView.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 18/02/25.
//

import SwiftUI
import Combine

// List of job roles
let jobRoles = [
    "Intern", "Junior Level", "Mid Level", "Senior Level", "Lead Level",
    "Manager", "Director", "Vice President", "Chief Technology Officer (CTO)",
    "Chief Information Officer (CIO)", "Chief Product Officer (CPO)",
    "Chief Operating Officer (COO)", "Chief Executive Officer (CEO)"
]

struct UpdateJobRole2View: View {
   
//    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
    
    @EnvironmentObject private var themeManager : ThemeManager
  
    @Environment(\.presentationMode) var presentationMode
   
    @State var isFristTimeUpdatingJobRole = false;
    
    @State private var birthDate = Date()
    
    @State var IsNoItemsSelected = false;
  
    var showNextButton : Bool = false ;
    @State var responseMessage : String = ""
    @State var selectedItem : SelectableItem? = nil;
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),

    ]
    

    
    @State var items: [SelectableItem] = jobRoles.map { SelectableItem(name: $0) }
    
    @State var status: String? = nil
    
    func toggleSelection(for item: SelectableItem) {
        for index in items.indices {
            selectedItem = item;
            items[index].isSelected = (items[index].id == item.id)
        }
    }
    
    func submitSelection(authToken : String) async {
        
        guard let selectedJobRole = selectedItem?.name as? String else {
            print("Please select a job role")
            return
        }
        
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
                            
                            if ( !isFristTimeUpdatingJobRole && showNextButton == false) {
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
        
        VStack ( alignment: .leading ) {
            
            HStack {
                
                Text("Job Role")
                    .font(.title) // Use .subheadline or .callout for smaller text
                    
                    .modifier(ThemedTextModifier())
                    
                    
             
                Spacer();
                
            }.padding()
            
            
            HStack {
                
               
                Image("jobRole").resizable().frame(width: 64, height: 64).padding(.horizontal , 100 )
             
               
            }.frame(maxWidth: .infinity)
           
            HStack {
             
                
                Text("\(selectedItem?.name ?? "No item selected")").foregroundColor(.black.opacity(0.8))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding().background(themeManager.currentTheme.secondaryColor.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.bottom , 10)
                
                
                Spacer()
            }
            ScrollViewReader { proxy in
                ScrollView {
                    //
                    //                Text("")
                    //                    .font(.largeTitle)
                    //                    .fontWeight(.bold)
                    //                    .padding()
                    //
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items) { item in
                            ItemView(item: item)
                                .onTapGesture {
                                    toggleSelection(for: item)
                                }
                        }
                    }
                    
                   
                    Color.clear.frame(height: 30)
                    
                }
                    .onAppear {
                    // Scroll to the item you want, replace `item.id` with the actual ID of the item you want to scroll to
                    if let itemToScrollTo = items.first(where: { $0.name == tokenManger.jobRole }) {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                proxy.scrollTo(itemToScrollTo.name, anchor: .center) // You can change `anchor` as needed
                            }
                        }
                       
                    }
                }
            }
            .alert(isPresented: $IsNoItemsSelected) {
                Alert(title: Text("Required"), message: Text("Please Select Atleast One Technology"), dismissButton: .default(Text("OK")))
            }
            
           .onAppear(){
                // Assuming tokenManager.technologies is a string containing comma-separated values
                
                if tokenManger.jobRole == "" {
                    isFristTimeUpdatingJobRole = true;
                }
                
                // Find the index of the item that matches the job role
                if let index = items.firstIndex(where: { $0.name == tokenManger.jobRole }) {
                    // Update the selected item at that index
                    items[index].isSelected = true
                    selectedItem = items[index]
                }
               
            }
            
            Button(showNextButton ? "Next" : Constants.Strings.submitButtonTitle , action: {
             
                Task {
                    await  submitSelection( authToken: tokenManger.accessToken)
                    
                }
            }).buttonStyle(ThemedButtonStyle()).padding(.horizontal)
            
//            {
//                Text( showNextButton ? "Next" : "Submit")
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
            
//            if let status = status , status == "suceess"  {
//                Text(status)
//                    .foregroundColor(.green)
//                    .padding()
//            }
        }.padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline).background( themeManager.currentTheme.backgroundColor) // Keeps the back button // Conditionally add padding.navigationBarTitle("", displayMode: .inline) // Keeps the back button
    }
}


#if DEBUG
struct UpdateJobRole2_Previews: PreviewProvider {
//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    static var previews: some View {
        UpdateJobRole2View( ).environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}
#endif


