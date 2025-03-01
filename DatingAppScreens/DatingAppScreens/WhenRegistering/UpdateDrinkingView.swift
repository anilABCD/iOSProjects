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

 

struct UpdateDrinkingView: View {
   
//    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
    
    @EnvironmentObject private var themeManager : ThemeManager
  
    @Environment(\.presentationMode) var presentationMode
   
    @State var isFirstTimeDrinkingUpdate = false;
    
    @State private var birthDate = Date()
    
    @State var IsNoItemsSelected = false;
  
    var showNextButton : Bool = false ;
    
    @State var selectedItem : SelectableItem? = nil;
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),

    ]
    
    @State var items: [SelectableItem] = [
        
        SelectableItem(name: "Never"),
        SelectableItem(name: "Socially"),
        SelectableItem(name: "Occasionally"),
        SelectableItem(name: "Frequently"),
        
    ]
    
    @State var status: String? = nil
    
    func toggleSelection(for item: SelectableItem) {
        for index in items.indices {
            selectedItem = item;
            items[index].isSelected = (items[index].id == item.id)
        }
    }
    
    func submitSelections( authToken : String ) {
      
       guard let url = URL(string: "\(tokenManger.localhost)/profiles/smoking-drinking-dob") else { return }
       
        guard let selectedItem = selectedItem else { return }
     
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       
       let token = authToken;
       
       print (token)
       request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
       
        
       
       
        let body = [ "drinking" : selectedItem.name  ] as [String : String]
       request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
       
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               print("Failed to submit selections: \(error)")
               return
           }
           
           guard let data = data else {
               print("No data received")
               return
           }
           
           if let responseMessage = try? JSONDecoder().decode(AuthResponse.self, from: data) {
               DispatchQueue.main.async {
                   self.status = responseMessage.status ?? "";
                   
                   print(self.status )
                 
                   if self.status == "success" {
                       
                       if ( !isFirstTimeDrinkingUpdate && showNextButton == false ) {
                           presentationMode.wrappedValue.dismiss()
                       }
                   }
                   
                   self.tokenManger.updateDrinking(drinking: selectedItem.name )
                   
                   
                   self.tokenManger.nextButtonWhenRegistrationProcess = UUID() ;
                   
               }
           } else {
               print("Failed to decode response")
           }
       }.resume()
   }
    
    
    var body: some View {
        
        VStack ( alignment: .leading ) {
            
            HStack {
                
                Text("Drinking")
                    .font(.title) // Use .subheadline or .callout for smaller text
                    
                    .modifier(ThemedTextModifier())
                    
                    
             
                Spacer();
                
            }.padding()
            
            HStack {
             
                
                Text("\(selectedItem?.name ?? "No item selected")").lineLimit(1).foregroundColor( themeManager.currentTheme.id == "light" ? .black.opacity(0.8) :  .white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding().background(themeManager.currentTheme.secondaryColor.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal, 30)
                    .padding(.bottom , 10)
                
                
                Spacer()
            }
            
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
              
                .alert(isPresented: $IsNoItemsSelected) {
                    Alert(title: Text("Required"), message: Text("Please Select Atleast One Technology"), dismissButton: .default(Text("OK")))
                }
                
               
            }.onAppear(){
                // Assuming tokenManager.technologies is a string containing comma-separated values
                
                if tokenManger.technologies == "" {
                    isFirstTimeDrinkingUpdate = true;
                }
                
                let technologiesArray = tokenManger.smoking.split(separator: ",").map { String($0) }
                
                 
                // Find the index of the item that matches the job role
                if let index = items.firstIndex(where: { $0.name == tokenManger.drinking }) {
                    // Update the selected item at that index
                    items[index].isSelected = true
                    selectedItem = items[index]
                }
               
               
            }
            
            Button(showNextButton ? "Next" : Constants.Strings.submitButtonTitle , action: {
                submitSelections( authToken: tokenManger.accessToken)
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
struct UpdateDrinkingView_Previews: PreviewProvider {
//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    static var previews: some View {
        UpdateDrinkingView( ).environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}
#endif


