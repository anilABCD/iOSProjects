import SwiftUI
import Combine


struct SelectableItem: Identifiable {
    let id = UUID()
    let name: String
    var isSelected: Bool = false
}



struct UpdateTechnologyNewView: View {
   
    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
  
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
//        GridItem(.flexible())
    ]
    
  
    @State var items: [SelectableItem] = [
        SelectableItem(name: "#React"),
        SelectableItem(name: "#Angular"),
        SelectableItem(name: "#React Native"),
        SelectableItem(name: "#Flutter"),
        SelectableItem(name: "#iOS"),
        SelectableItem(name: "#Android"),
        SelectableItem(name: "#Swift UI"),
        SelectableItem(name: "#Front End"),
        SelectableItem(name: "#Backend"),
        SelectableItem(name: "#Fullstack"),
        SelectableItem(name: "#Dev Ops")
    ]
    
    @State var status: String? = nil
    
    func toggleSelection(for item: SelectableItem) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].isSelected.toggle()
        }
    }
    
    func submitSelections( authToken : String ) {
        let selectedItems = items.filter { $0.isSelected }.map { $0.name }
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
                    
                    print(self.status)
                    print (responseMessage.data?.user?.technologies)
                    
                    self.tokenManger.technologies =  selectedItems.joined(separator: ",");
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    
    var body: some View {
        VStack {
            
            Text("Technologies")
                          .font(.largeTitle)
                          .fontWeight(.bold)
                          .padding()
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(items) { item in
                    ItemView(item: item)
                        .onTapGesture {
                            toggleSelection(for: item)
                        }
                }
            }
            .padding()
            
            Button(action: {
                submitSelections( authToken: tokenManger.accessToken)
            }) {
                Text("Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            if let status = status , status == "suceess"  {
                Text(status)
                    .foregroundColor(.green)
                    .padding()
            }
        }
       
        .padding()
    }
}

struct ItemView: View {
    let item: SelectableItem
    
    var body: some View {
        Text(item.name)
            .font(.headline)
            .foregroundColor(item.isSelected ? .white : .white)
            .padding(4)
            .frame(maxWidth: .infinity)
            .background(item.isSelected ? Color.blue : Color.gray)
            .clipShape(Capsule())
                        .overlay(Capsule().stroke(Color.white, lineWidth: 1))
                        .lineLimit(1)
    }
}

struct UpdateTechnologyView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    @EnvironmentObject private var tokenManger : TokenManager
    static var previews: some View {
        UpdateTechnologyNewView(path: $path)
    }
}
