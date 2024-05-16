import SwiftUI

struct LoginView: View {
    
    @Binding var path :[MyNavigation<String>]
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var token: String?
    
    @State private var isShowingEmailError:Bool=false;
    @State private var isShowingPasswordError:Bool=false;
    @State private var isShowingConfirmPasswordError:Bool=false;
   
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20) 
               
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .keyboardType(.emailAddress)
                .alert(isPresented: $isShowingEmailError) {
                    Alert(title: Text("Invalid Email"), message: Text("Please enter a valid email address."), dismissButton: .default(Text("OK")))
                } .textContentType(.password)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .alert(isPresented: $isShowingPasswordError) {
                    Alert(title: Text("Invalid Password"), message: Text("Password should contain at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character."), dismissButton: .default(Text("OK")))
                
                } .textContentType(.password)
                
            
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(5.0)
                .padding(.bottom, 20)
                .alert(isPresented: $isShowingConfirmPasswordError) {
                    Alert(title: Text("Invalid Confirm Password"), message: Text("Confirm password does not match the password."), dismissButton: .default(Text("OK")))
                }
            
            Button(action: {
                // Handle signup button action here
                
                validateInput()
                
//                let signUpData = SignUpData(name: name, email: email, password: password, passwordConfirm: confirmPassword, technology: ["#Swift UI"])
//                signUp(signUpData)
            }) {
                Text("Sign Up")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .bold))
                    .background(Color.blue)
                    .cornerRadius(5.0)
            }
            .padding(.horizontal, 20)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("Failed to sign up. Please try again."), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    
    private func validateInput() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            resetValidationFlags()
            
            print(isShowingEmailError , isShowingPasswordError , isShowingConfirmPasswordError , showAlert)
            
        }
        
       
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
           
            resetValidationFlags()
            
            validateEmail()
            validatePassword()
            validateConfirmPassword()
            
            if isShowingEmailError || isShowingPasswordError || isShowingConfirmPasswordError {
                // Perform signup
                showAlert = true // For demo purpose
                
                
            }
            else{
                path.append(MyNavigation<String> ( appView: .step2, params: Params<String>(data: "")))
            }
            
            
            print(isShowingEmailError , isShowingPasswordError , isShowingConfirmPasswordError , showAlert)
            
            
        }
    }
    
    private func resetValidationFlags() {
           isShowingEmailError = false
           isShowingPasswordError = false
           isShowingConfirmPasswordError = false
        
        showAlert=false;
       }
       
    
    func signUp(_ data: SignUpData) {
        Task {
            guard let url = URL(string: "http://localhost:8000/auth/signup") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                request.httpBody = try JSONEncoder().encode(data)
            } catch {
                print("Error encoding data: \(error.localizedDescription)")
                return
            }
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                if let decodedResponse = try? JSONDecoder().decode(AuthResponse.self, from: data) {
                    // Save token locally
                    self.token = decodedResponse.token
                    print("Token: \(self.token ?? "No token received")")
                    // Handle successful signup, maybe navigate to another view
                } else {
                    // Show error alert
                    self.showAlert = true
                    print("Invalid response from server")
                }
            }.resume()
        }
        
        
        
    }
    private func validateEmail() {
           // Regular expression for email validation
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           isShowingEmailError = !emailPredicate.evaluate(with: email)
       }
       
       private func validatePassword() {
           // Regular expression for password validation
           let passwordRegex = "^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"
           let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)
           isShowingPasswordError = !passwordPredicate.evaluate(with: password)
       }
       
       private func validateConfirmPassword() {
           isShowingConfirmPasswordError = (password != confirmPassword)
       }

    
 
}

struct LoginView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        LoginView(path: $path)
    }
}
