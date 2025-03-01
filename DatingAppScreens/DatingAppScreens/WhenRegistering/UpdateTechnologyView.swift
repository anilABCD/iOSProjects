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
    
    @EnvironmentObject private var themeManager : ThemeManager
  
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
    
    func getSelectedItems ( ) -> String
    {
        let selectedItems = items
                .filter { $0.isSelected }
                .map { String($0.name.dropFirst()) } // Convert Substring to String
                .joined(separator: ", ") // Removed extra space before the comma

            return selectedItems.isEmpty ? "No Item Selected" : selectedItems
    }
    
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
                    
                    .modifier(ThemedTextModifier())
                    
                    
             
                Spacer();
                
            }.padding()
            
            
            HStack {
                
                Image("technologies2").resizable().frame(width: 64, height: 64).padding(.horizontal , 100 ).opacity(0.8)
             
               
            }
           
            HStack {
             
                
                Text("\(getSelectedItems())").lineLimit(1).foregroundColor( themeManager.currentTheme.id == "light" ? .black.opacity(0.8) :  .white)
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

struct ItemView: View {
    let item: SelectableItem
    @EnvironmentObject private var themeManager : ThemeManager
    var body: some View {
        Text(item.name)
            .fontWeight(item.isSelected ? .semibold : .regular)
            .font( .system(size: 14))
            .foregroundColor(item.isSelected ? ( themeManager.currentTheme.id == "light" ?  .white : .black ) : ( themeManager.currentTheme.id == "light" ?  .black : .white ) )
            .padding(.vertical, 10)
            .padding(.horizontal)
           
            .cornerRadius(10) // Apply a corner radius of 10 instead of Capsule
            .frame(width: 140)
            .background(item.isSelected ? themeManager.currentTheme.buttonColor : Color.gray.opacity(0.04))
            .cornerRadius(10) // Apply a corner radius of 10 instead of Capsule
            .overlay(item.isSelected ?  RoundedRectangle(cornerRadius: 10).stroke(themeManager.currentTheme.buttonColor, lineWidth: 1) : RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1)) // Use a rounded rectangle for the border
          
            .frame(width: 140).lineLimit(1)
                        .id(item.name)
                       
                       
    }
}

struct UpdateTechnologyView_Previews: PreviewProvider {
//    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    static var previews: some View {
        UpdateTechnologyNewView( ).environmentObject(TokenManager()).environmentObject(ThemeManager())
    }
}
