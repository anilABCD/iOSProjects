
import SwiftUI
import Combine


struct UpdateHobbiesView: View {
   
   
    @EnvironmentObject private var tokenManger : TokenManager
    
    @EnvironmentObject private var themeManager : ThemeManager
    
    @Environment(\.presentationMode) var presentationMode
    @State var isFirstTimeUpdatingProfile = false;
    
    @State private var birthDate = Date()
    
    var showNextButton : Bool = false ;
    
    
    @State var IsNoItemsSelected = false;
  
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    
    
  
    @State var items: [SelectableItem] = [
        SelectableItem(name: "#Reading"),
        SelectableItem(name: "#Traveling"),
        SelectableItem(name: "#Cooking"),
        SelectableItem(name: "#Sports"),
        SelectableItem(name: "#Movies"),
        SelectableItem(name: "#Music"),
        SelectableItem(name: "#Dancing"),
        SelectableItem(name: "#Gaming"),
        SelectableItem(name: "#Hiking"),
        SelectableItem(name: "#Photography"),
        SelectableItem(name: "#Painting"),
        SelectableItem(name: "#Writing")
    ]
    
    
    @State var status: String? = nil
    
    func toggleSelection(for item: SelectableItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
        }
    }
    
    func submitSelections( authToken : String ) {
        let selectedItems = items.filter { $0.isSelected }.map { $0.name }
        
        if(selectedItems.isEmpty){
            IsNoItemsSelected = true;
            return;
        }
        
        guard let url = URL(string: "\(tokenManger.localhost)/profiles/hobbies") else { return }
        
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = authToken;
        
        print (token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        let body = ["hobbies": selectedItems]
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
                    self.status = responseMessage.status;
                    
                    print(self.status ?? "")
                    print (responseMessage.data?.user?.hobbies ?? "" )
                    
                    if(self.status == "success"){
                        if ( !isFirstTimeUpdatingProfile ) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    self.tokenManger.hobbies =  selectedItems.joined(separator: ",");
                    
                    if( !self.tokenManger.hobbies.isEmpty ) {
                        
                        tokenManger.nextButtonWhenRegistrationProcess = UUID();
                    }
                    
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    var body: some View {
        
        VStack (spacing: 0 ) {
            
            
            HStack {
                
                Text("Hobbies")
                    .font(.title) // Use .subheadline or .callout for smaller text
                    .modifier(ThemedTextModifier())
             
                Spacer();
                
            }.padding()
            
            
            HStack {
                
                Image("hobbies").resizable().frame(width: 74, height: 74).padding(.horizontal , 100 )
             
               
            }
           
            
            ScrollView {
//                
//                Spacer()
////                VStack {
////                    Text("Select your date of birth")
////                        .font(.headline)
////                    
////                    DatePicker("Date of Birth", selection: $birthDate, in: ...Date(), displayedComponents: .date)
////                        .datePickerStyle(WheelDatePickerStyle())
////                        .labelsHidden()
////                    
////                    Text("Selected Date: \(formattedDate(date: birthDate))")
////                        .padding()
////                }.padding(0)
//                
////                
//                Text("")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                    .padding()
                
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(items) { item in
                        ItemView(item: item)
                            .onTapGesture {
                                toggleSelection(for: item)
                            }
                    }
                }
                .padding()
                .alert(isPresented: $IsNoItemsSelected) {
                    Alert(title: Text("Required"), message: Text("Please Select Atleast One Hobby"), dismissButton: .default(Text("OK")))
                }
                
               
            }.onAppear(){
                // Assuming tokenManager.technologies is a string containing comma-separated values
                
                
                if tokenManger.hobbies == "" {
                    isFirstTimeUpdatingProfile = true;
                }
                
                let technologiesArray = tokenManger.hobbies.split(separator: ",").map { String($0) }
                
                // Iterate through each item in items
                for index in items.indices {
                    let selectedItem = items[index]
                    
                    // Check if the name of the selectedItem exists in technologiesArray
                    if let _ = technologiesArray.first(where: { $0 == selectedItem.name }) {
                        // If found, update the isSelected property
                        items[index].isSelected = true
                    }
                }
            }
            
            Button(showNextButton ? "Next" : Constants.Strings.submitButtonTitle , action: {
                submitSelections( authToken: tokenManger.accessToken)
            }).buttonStyle(ThemedButtonStyle()).padding(.horizontal)
            
//            {
//                Text(  )
//                    .font(.headline)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.blue)
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//            }
            
            if let status = status , status == "suceess"  {
                Text(status)
                    .foregroundColor(.green)
                    .padding()
            }
        }.padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline).background( themeManager.currentTheme.backgroundColor )
    }
}


struct UpdateHobbiesView_Previews: PreviewProvider {
    var showNextButton : Bool = false ;
    
    static var previews: some View {
        UpdateHobbiesView( showNextButton : true ).environmentObject(TokenManager())
    }
}
