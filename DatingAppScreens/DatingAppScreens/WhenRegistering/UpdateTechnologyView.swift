import SwiftUI
import Combine


struct SelectableItem: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
}



struct UpdateTechnologyNewView: View {
   
//    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
  
    @Environment(\.presentationMode) var presentationMode
   
    @State var isFirstTimeUpdatingProfile = false;
    
    @State private var birthDate = Date()
    
    @State var IsNoItemsSelected = false;
  
    var showNextButton : Bool = false ;
    
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),

    ]
    
    @State var items: [SelectableItem] = [
        
        SelectableItem(name: "#React"),
        SelectableItem(name: "#Angular"),
        SelectableItem(name: "#React Native"),
        SelectableItem(name: "#Flutter"),
        SelectableItem(name: "#iOS"),
        SelectableItem(name: "#Android"),
        SelectableItem(name: "#Swift"),
        SelectableItem(name: "#Swift UI"),
        
        SelectableItem(name: "#Node js"),
        SelectableItem(name: "#MERN"),
        SelectableItem(name: "#MEAN"),
        
       
        SelectableItem(name: "#Front End"),
        SelectableItem(name: "#UI/UX Designer"),
        SelectableItem(name: "#Backend"),
        SelectableItem(name: "#Fullstack"),
        SelectableItem(name: "#Dev Ops"),
        
        SelectableItem(name: "#Cloud Engineer"),
        SelectableItem(name: "#QA Engineer"),
        
        SelectableItem(name: "#AI/ML Engineer"),
        SelectableItem(name: "#Game Developer"),

        SelectableItem(name: "#Database"),
        SelectableItem(name: "#System Administrator"),
        SelectableItem(name: "#Security Engineer"),
        
        SelectableItem(name: "#Product Manager"),
        SelectableItem(name: "#CEO"),
        SelectableItem(name: "#Chairman"),
 
        SelectableItem(name: "#Data Scientist/Engineer"),
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
        
        guard let url = URL(string: "\(tokenManger.localhost)/profiles/technology") else { return }
        
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = authToken;
        
        print (token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
        let body = ["technologies": selectedItems]
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
                    
                    if( self.status == "success" ) {
                        if ( !isFirstTimeUpdatingProfile && showNextButton == false) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                  
                    
                    print(self.status ?? "")
                    print (responseMessage.data?.user?.technologies ?? "" )
                    
                    self.tokenManger.technologies =  selectedItems.joined(separator: ",");
                    
                    if ( !self.tokenManger.technologies.isEmpty ) {
                        tokenManger.nextButtonWhenRegistrationProcess = UUID();
                    }
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    var body: some View {
        
        VStack {
            
            HStack {
                
                Text("Technologies")
                    .font(.title) // Use .subheadline or .callout for smaller text
                    .foregroundColor(.primary)
             
                Spacer();
                
            }.padding()
            
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
                    isFirstTimeUpdatingProfile = true;
                }
                
                let technologiesArray = tokenManger.technologies.split(separator: ",").map { String($0) }
                
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
            
            Button(showNextButton ? "Next" : "Submit" , action: {
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
            
            if let status = status , status == "suceess"  {
                Text(status)
                    .foregroundColor(.green)
                    .padding()
            }
        }.padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline) // Keeps the back button // Conditionally add padding.navigationBarTitle("", displayMode: .inline) // Keeps the back button
    }
}

struct ItemView: View {
    let item: SelectableItem
    @EnvironmentObject private var themeManager : ThemeManager
    var body: some View {
        Text(item.name)
            .fontWeight(item.isSelected ? .semibold : .regular)
            .foregroundColor(item.isSelected ? .white : .black)
            .padding(.vertical, 10)
            .padding(.horizontal)
            .background(item.isSelected ? themeManager.currentTheme.buttonColor : Color.white)
            .clipShape(Capsule())
            .overlay( item.isSelected ? nil : Capsule().stroke(Color.gray, lineWidth: 1))
                        .lineLimit(1)
                        
    }
}

struct UpdateTechnologyView_Previews: PreviewProvider {
//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    static var previews: some View {
        UpdateTechnologyNewView( ).environmentObject(TokenManager())
    }
}
