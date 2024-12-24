import SwiftUI

struct UpdateDescribeYourselfView : View {
    @State private var bio: String = ""
    @State private var showSuccessMessage: Bool = false
    @State private var showError: Bool = false
    private let maxLetters = 200
    @EnvironmentObject private var tokenManger : TokenManager
    @Binding var path :[MyNavigation<String>]
    
    var body: some View {
        NavigationView {
           
            VStack(spacing: 20) {
                
              
                VStack(alignment: .leading) {
                    
                   
                    Text("Your Bio")
                        .font(.headline)
                        .foregroundColor(.gray)

                    TextEditor(text: $bio)
                        .frame(height: 150)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .onChange(of: bio) { newValue in
                            if newValue.count > maxLetters {
                                bio = String(newValue.prefix(maxLetters))
                            }
                        }

                    HStack {
                        Spacer()
                        Text("\(bio.count)/\(maxLetters) characters")
                            .font(.caption)
                            .foregroundColor(bio.count == maxLetters ? .red : .gray)
                    }
                }
              
                
                Spacer()
                
                Button(action: {
                    Task {
                        await submitDetails()
                    }
                }) {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .disabled(bio.isEmpty)
                .opacity(bio.isEmpty ? 0.5 : 1.0)
                .alert(isPresented: $showSuccessMessage) {
                    Alert(title: Text("Success"), message: Text("Your details have been submitted!"), dismissButton: .default(Text("OK")))
                }
                .alert(isPresented: $showError) {
                    Alert(title: Text("Error"), message: Text("Failed to submit details. Please try again."), dismissButton: .default(Text("OK")))
                }

               
            }
            .padding()
            .navigationTitle("Describe Yourself")
        }
    }

    func submitDetails() async {
        guard !bio.isEmpty else {
            showError = true
            return
        }

        let userDetails = ["bio": bio]

        do {
            let request = try createURLRequest(
                method: "POST",
                baseURL: "https://example.com/api/submitDetails",
                accessToken: "your_access_token_here",
                data: userDetails,
                parameters: nil
            )

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    showSuccessMessage = true
                }
            } else {
                DispatchQueue.main.async {
                    showError = true
                }
            }
        } catch {
            DispatchQueue.main.async {
                showError = true
            }
        }
    }

//    func createURLRequest<T: Encodable>(
//        method: String,
//        baseURL: String,
//        accessToken: String,
//        data: T?,
//        parameters: [String: String]?
//    ) throws -> URLRequest {
//        var urlComponents = URLComponents(string: baseURL)
//        if let parameters = parameters {
//            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        }
//        guard let url = urlComponents?.url else {
//            throw StringError(message: "Failed to create URL")
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = method
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
//        if let data = data {
//            if let encodedData = try? JSONEncoder().encode(data) {
//                request.httpBody = encodedData
//            }
//        }
//        return request
//    }
}

//struct StringError: Error {
//    let message: String
//}

struct UpdateDescribeYourselfView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
    static var previews: some View {
        UpdateDescribeYourselfView(path: $path).environmentObject(TokenManager())
    }
}
