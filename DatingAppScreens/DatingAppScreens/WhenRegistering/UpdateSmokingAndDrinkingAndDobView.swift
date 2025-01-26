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
        self.selectedDOB = Calendar.current.date(byAdding: .year, value: -15, to: Date()) ?? Date()
    }
}

// Main View
struct UpdateSmokingAndDrinkingAndDOBView: View {
    
    @StateObject private var viewModel = ProfileEditorViewModel()
    @State private var showAlert = false
    @State private var showDOBPicker = false
    @State var isFirstTimeUpdatingProfile = false;
    
    @Environment(\.presentationMode) var presentationMode
    
    var showNextButton: Bool = false
   
    enum AlertType : Identifiable{
        case ageLessThan15
        case ageGreaterThan60
        
        var id: Self { self }
    }

     @State var status : String = ""
    
    @State private var alertType: AlertType? = nil

    @EnvironmentObject private var tokenManger : TokenManager
    
 
    private func checkIfDOBIsGreaterThan15YearsAge(date: Date) -> Bool {
        
        let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for:)
 
        // Calculate 15 years ago, at the end of the day (23:59:59.999...)
        let fifteenYearsAgoEndOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: calendar.startOfDay(for: calendar.date(byAdding: .year, value: -15, to: Date()) ?? Date())) ?? Date()

        return date <= fifteenYearsAgoEndOfDay // Checks if the date is older than 15 years
    }
    
    
    private func checkIfDOBIsLessThan60YearsAge(date: Date) -> Bool {
        
        let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for:)

        // Calculate 60 years ago
        let sixtyYearsAgo = calendar.startOfDay(for: calendar.date(byAdding: .year, value: -60, to: Date()) ?? Date())
        
        // Check if the date is older than 15 years but not older than 60 years
        return date >= sixtyYearsAgo
    }
    
    func validateAge(date: Date) -> Bool {
        
        if ( !checkIfDOBIsGreaterThan15YearsAge(date: date) )
        {
            alertType = .ageLessThan15
            
            return false ;
        }
        else
        if ( !checkIfDOBIsLessThan60YearsAge(date: date) ) {
            
            alertType = .ageGreaterThan60
            
            return false ;
        }
        else {
            return true ;
        }
    }
    
     func submitSelections( authToken : String ) {
       
        guard let url = URL(string: "\(tokenManger.localhost)/profiles/smoking-drinking-dob") else { return }
        
        guard validateAge(date: viewModel.selectedDOB) else { return }
      
        
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
                  
                    if self.status == "success" {
                        showAlert = true;
                        if ( !isFirstTimeUpdatingProfile && showNextButton == false ) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    
                    self.tokenManger.updateProfileDobSmokingDrinkingEmpty(dob: convertToString(from: viewModel.selectedDOB ) , drinking: viewModel.selectedDrinking.name , smoking: viewModel.selectedSmoking.name )
                    
                    
                    self.tokenManger.nextButtonWhenRegistrationProcess = UUID() ;
//
                    print ( formattedDOB(date: viewModel.selectedDOB ))
                    
                }
            } else {
                print("Failed to decode response")
            }
        }.resume()
    }
    

    var body: some View {
        VStack(spacing: 0){
            
            VStack {
                List {
                    
                    
                    Section("Date Of Birth") {
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
                        
                        
//                        .background(Color(.systemGray6))
                    }.alert(item: $alertType) { alertType in
                        
                        switch alertType {
                                case .ageLessThan15:
                                    return Alert(
                                        title: Text("Alert"),
                                        message: Text("Your date of birth should be greater than 15 years."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                case .ageGreaterThan60:
                                    return Alert(
                                        title: Text("Alert"),
                                        message: Text("Your date of birth should be less than 60 years."),
                                        dismissButton: .default(Text("OK"))
                                    )
                                }
                        
                        
                    }
                  
                   
                    Section("Habbits") {
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
                    }
                    
                    //                Text("Selected Drinking: \(viewModel.selectedDrinking.name)")
                    //                    .padding()
                    //                Text("Selected Smoking: \(viewModel.selectedSmoking.name)")
                    //                    .padding()
                    //
                }.listStyle(PlainListStyle())
            }.onAppear(){
                // Update viewModel with tokenManager's values
                
                
                if tokenManger.isProfileDobSmokingDrinkingEmpty() == true {
                    isFirstTimeUpdatingProfile = true;
                }
                
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
            }.padding(0)
            
            Spacer()
            
            
            Button(action: {
                submitSelections( authToken: tokenManger.accessToken)
            }) {
                Text(showNextButton ? "Next" : "Submit")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
//            .alert(isPresented: $showAlert) {
//                Alert(
//                    title: Text("Success"),
//                    message: Text("Profile saved successfully!"),
//                    dismissButton: .default(Text("OK")) {
//                        
//                        presentationMode.wrappedValue.dismiss()
//                    }
//                )
//            }
            
            Spacer()
        }.padding(.bottom, showNextButton ? 0 : 110).navigationBarTitle("", displayMode: .inline)
        
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
    
    private func formattedDOB(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}


//
//struct DateAlertView: View {
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Alert")
//                .font(.title)
//                .bold()
//            
//            Text("The selected date is greater than 15 years ago.")
//                           .font(.body)
//
//            Button("Close") {
//                // Dismiss sheet using environment
//                dismiss()
//            }
//            .buttonStyle(.borderedProminent)
//        }
//        .padding()
//    }
//
//    // Helper function to dismiss the sheet
//    @Environment(\.dismiss) private var dismiss
//}

struct ProfileEditorView_Previews: PreviewProvider {
    var showNextButton: Bool = false
    
    static var previews: some View {
        UpdateSmokingAndDrinkingAndDOBView( showNextButton : true ).environmentObject(TokenManager())
    }
}




