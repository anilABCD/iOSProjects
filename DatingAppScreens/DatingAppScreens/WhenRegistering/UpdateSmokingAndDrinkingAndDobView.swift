import SwiftUI
import Combine

// Model for option
struct Option: Identifiable , Hashable{
    let id = UUID()
    let name: String
}

// Drinking and Smoking options
let drinkingOptions: [Option] = [
    Option(name: "Never"),
    Option(name: "Socially"),
    Option(name: "Occasionally"),
    Option(name: "Frequently")
]

let smokingOptions: [Option] = [
    Option(name: "Never"),
    Option(name: "Occasionally"),
    Option(name: "Regularly"),
    Option(name: "Trying to Quit")
]

// ViewModel to manage selection state
class ProfileEditorViewModel: ObservableObject {
    @Published var selectedDrinking: Option
    @Published var selectedSmoking: Option
    @Published var selectedDOB: Date
    
    init() {
        // Default selections
        self.selectedDrinking = drinkingOptions.first!
        self.selectedSmoking = smokingOptions.first!
        self.selectedDOB = Date()
    }
}

// Main View
struct ProfileEditorView: View {
    
    @StateObject private var viewModel = ProfileEditorViewModel()
    
    @State private var showDOBPicker = false
    
     @State var status : String = ""
    
    @EnvironmentObject private var tokenManger : TokenManager
    
    
     func submitSelections( authToken : String ) {
       
        guard let url = URL(string: "\(tokenManger.localhost)/profiles/smoking-drinking-dob") else { return }
        
       
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let token = authToken;
        
        print (token)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        
        
         let body = ["drinking": viewModel.selectedDrinking.name , "smoking" : viewModel.selectedSmoking.name , "dob" : convertToString(from : viewModel.selectedDOB) ] as [String : String]
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
                  
        
                    self.tokenManger.updateProfileDobSmokingDrinkingEmpty(dob: convertToString(from: viewModel.selectedDOB ) , drinking: viewModel.selectedDrinking.name , smoking: viewModel.selectedSmoking.name )
       
                    print ( formattedDOB(date: viewModel.selectedDOB ))
                    
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    

    var body: some View {
        VStack {
            
            List {
                
                // Date of Birth Picker
                HStack() {
                    
                    Text("Date of Birth")
                        .foregroundColor(.primary)
                        .padding(.leading)
                    Spacer()
                    HStack {
                        TextField("", text: .constant(formattedDOB(date: viewModel.selectedDOB)))
                            .disabled(true)
                            .padding(.horizontal)
                            .onTapGesture {
                                showDOBPicker.toggle()
                            }
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .padding(.trailing)
                            .onTapGesture {
                                showDOBPicker.toggle()
                            }
                    }
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
                .sheet(isPresented: $showDOBPicker) {
                    ZStack {
//                        Color.black.opacity(0.3) // Semi-transparent black background
                        
                        VStack {
                            DatePicker("", selection: $viewModel.selectedDOB, displayedComponents: .date)
                                .datePickerStyle(WheelDatePickerStyle())
                                .labelsHidden()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(8)
                                .padding()
                            
                            Button(action: {
                                showDOBPicker.toggle()
                            }) {
                                Text("OK")
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(8)
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .background(Color.clear) // Ensure background is transparent
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    showDOBPicker = false // Dismiss sheet on background tap
                                }
                        )
                    }
                    .edgesIgnoringSafeArea(.all) // Ignore safe area for full-screen effect
                }

                .background(Color(.systemGray6))
                
                
                
                // Smoking Picker
                HStack() {
                    Text("Smoking")
                        .foregroundColor(.primary)
                        .padding(.leading)
                    
                    Picker("", selection: $viewModel.selectedSmoking) {
                        ForEach(smokingOptions) { option in
                            Text(option.name).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
              
                
                
                // Drinking Picker
                HStack() {
                    Text("Drinking")
                        .foregroundColor(.primary)
                        .padding(.leading)
                    
                    Picker("", selection: $viewModel.selectedDrinking) {
                        ForEach(drinkingOptions) { option in
                            Text(option.name).tag(option)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

//                Text("Selected Drinking: \(viewModel.selectedDrinking.name)")
//                    .padding()
//                Text("Selected Smoking: \(viewModel.selectedSmoking.name)")
//                    .padding()
//                
            }.onAppear(){
                // Update viewModel with tokenManager's values
                              if let dob = convertToDate(from: tokenManger.dob) {
                                  viewModel.selectedDOB = dob
                                  
                                  print (dob,tokenManger.dob)
                              }
                else{
                    print ("no dob")
                }
                              
                              if let smokingOption = smokingOptions.first(where: { $0.name == tokenManger.smoking }) {
                                  viewModel.selectedSmoking = smokingOption
                              }
                              
                              if let drinkingOption = drinkingOptions.first(where: { $0.name == tokenManger.drinking }) {
                                  viewModel.selectedDrinking = drinkingOption
                              }
            }
            
            
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
        }
    }
    
    func convertToDate(from dateString: String) -> Date? {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
           return dateFormatter.date(from: dateString)
       }

       func convertToString(from date: Date) -> String {
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
           dateFormatter.locale = Locale(identifier: "en_US_POSIX")
           dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
           return dateFormatter.string(from: date)
       }
    
    func convertStringToDate(_ dateString: String) -> Date? {
           let formatter = ISO8601DateFormatter()
           let date = formatter.date(from: dateString)
        
           print (date )
           return date
       }
    
    
      func convertStringToDateUsingCustomeDateFormatter(_ dateString: String) -> Date? {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd-MMM-yyyy"
          return formatter.date(from: dateString)
      }
      
    
    private func formattedDOB(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ProfileEditorView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditorView().environmentObject(TokenManager())
    }
}




