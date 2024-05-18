import SwiftUI

import GoogleSignInSwift

import GoogleSignIn

struct StringError: Error, LocalizedError {
    let message: String

    var errorDescription: String? {
        return message
    }
}

struct ErrorResponse: Decodable {
    let error: String
    let details: [String: String]?
}

struct RegisterView: View {
    
    @EnvironmentObject var environmentManager: TokenManager
    
    @Binding var path :[MyNavigation<String>]
    
    @State private var name: String = "asdf"
    @State private var email: String = "Anil@gmail.com"
    @State private var password: String = "Password@123"
    @State private var confirmPassword: String = "Password@123"
    @State private var showAlert: Bool = false
    @State private var showDuplicateAlert : Bool = false
    @State private var token: String?
    
    @State private var isUserCreated :Bool = false;
    @State private var errorMessage : String = "";
    
    @State private var isShowingNameError:Bool=false;
    @State private var isShowingEmailError:Bool=false;
    @State private var isShowingPasswordError:Bool=false;
    @State private var isShowingConfirmPasswordError:Bool=false;
    
    @State private var isLoading = false;
   
    func handleSignInButton() {
           guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
               return
           }
           
           GIDSignIn.sharedInstance.signIn(
               withPresenting: rootViewController) { signInResult, error in
                   guard let result = signInResult else {
                       if let error = error {
                           print("Error signing in: \(error.localizedDescription)")
                       }
                       return
                   }
                   // If sign-in succeeded, display the app's main content view.
                   let user = result.user
                   let idToken = user.idToken?.tokenString as String?
                   let fullName = user.profile?.name
                   let email = user.profile?.email
                   
                   // Handle the signed-in user's information
                   print("User signed in: \(fullName ?? "No Name"), email: \(email ?? "No Email") , idToken : \(idToken)");
                   
                   
                   
                   if let googleToken = idToken {
                       let signInWithGoogleData = SignInWithGoogleData(token: googleToken )
                       
                       signInWithGoogle(signInWithGoogleData)
                   }
                   
               }
       }
    
    
    var body: some View {
        
        
        VStack {
        
            if(UIScreen.main.bounds.height < 800 ) {
                
                Spacer().frame(height: 100)
            }
            else{
                Spacer().frame(height: 200)
            }
            
            VStack {
                if isLoading {
                                
                    
                    ProgressView()
                                          .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                          .scaleEffect(1.5) // Make the indicator larger
                }
            }
          
            
            VStack {
                
                // Title
                Text("Sign Up")
                 
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical)
                   
                Spacer().frame(height: 40)
                
                // Input Fields
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Name", text: $name, isAlert: $isShowingNameError , iconName: "person.fill" , title: "" , message: "")
                    CustomTextField(placeholder: "Email", text: $email, isAlert: $isShowingEmailError ,iconName: "envelope.fill" , title: "Invalid Email" , message: "Please enter a valid email address.")
                    CustomTextField(placeholder: "Password", text: $password, isAlert: $isShowingPasswordError, iconName: "lock.fill", isSecure: true , title: "Invalid Password" , message: "Password should contain at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.")
                    CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isAlert: $isShowingConfirmPasswordError , iconName: "lock.fill", isSecure: true , title: "Invalid Confirm Password" , message: "Confirm password does not match the password.")
                    
                } .padding(.horizontal, 30)
                
                VStack{
                    Button(action: {
                        // Handle signup button action here
                        
                        validateInput()
                        
                    }) {
                        Text("Submit")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .bold))
                            .background(Color.orange)
                            .cornerRadius(50)
                    }
                    .padding(.horizontal, 20)
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Error"), message: Text("Failed to sign up. Please try again."), dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $showDuplicateAlert) {
                        Alert(title: Text("Sign Up Failed"), message: Text("User Already Exists."), dismissButton: .default(Text("OK")))
                    }
                    .alert(isPresented: $isUserCreated) {
                        Alert(title: Text("Success"), message: Text("User Created Successfully."), dismissButton: .default(Text("OK")) {
                                path.append(MyNavigation<String> ( appView: .page2, params: Params<String>(data: "")))
                            })  }
                    
                    // Social Sign-In
                                HStack(spacing: 20) {
                                    Button(action: {
                                        handleSignInButton()
                                    }) {
                                        Image( "googleIcon") // Replace with your Google icon image
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                    }
                                    
//                                    // Social Sign-In
//                                              GoogleSignInButton(action: handleSignInButton)

                                    
//                                    Button(action: {
//                                        // Handle Facebook sign-in action here
//                                    }) {
//                                        Image("facebookIcon") // Replace with your Facebook icon image
//                                            .resizable()
//                                            .frame(width: 35, height: 35)
//                                    }
                                }
                               
                                
                                // Additional Options
                                HStack {
                                    Text("Already have an account?")
                                    Button(action: {
                                        path.removeLast()
                                    }) {
                                        Text("Sign In")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding(.top, 20)
                                
                                Spacer()
                }.frame(alignment: .topLeading )
                .padding()
                
                
            
                Spacer()
            }.background(.white).cornerRadius(40, corners: [.topLeft, .topRight]).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        }.background(.orange).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
          
//
// Code for skeleton View :
//
//            .overlay(
//            Group {
//                if isLoading {
//                    SkeletonView();
//                }
//            }
//           )
//            
//            .onAppear {
//            Task {
//                // Simulate loading process
//                try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds delay
//                isLoading = false
//            }
//        }
//
        
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
                
                let signUpData = SignUpData(name: name, email: email, password: password, passwordConfirm: confirmPassword, technology: ["#Swift UI"])
            
           
                Task {
                    do {
                        isLoading = true;
                        
                        defer {
                                       isLoading = false
                                   }
                        
                        try await signUp(signUpData)
                       
                    } catch {
                        
                        print ("error")
                    }
                }
                
         }
            
            
            print(isShowingEmailError , isShowingPasswordError , isShowingConfirmPasswordError , showAlert)
            
            
        }
    }
    
    private func resetValidationFlags() {
           isShowingEmailError = false
           isShowingPasswordError = false
           isShowingConfirmPasswordError = false
        showDuplicateAlert = false;
        isUserCreated = false;
        
        showAlert=false;
       }
       
    
    func signUp(_ data: SignUpData) async throws {
        guard let url = URL(string: "http://localhost:8000/auth/signup") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(data)
        } catch {
            print (error.localizedDescription)
            throw error
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw StringError(message: "Invalid response received")
            }
            
            print ( "Invalid response received");
            
            if httpResponse.statusCode >= 400 {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    
                    if errorResponse.error == "DUPLICATE_USER" {
                        self.showDuplicateAlert = true
                        throw StringError(message: "DUPLICATE_USER")
                    }
                } catch {
                    print (error.localizedDescription)
                    throw StringError(message: "Failed to decode error response")
                }
                return
            }
            
           
            do {
                let decodedResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
              
                if ( decodedResponse.token != "" ) {
    
                    self.token =  decodedResponse.token
                    self.isUserCreated = true
                } else {
                    self.errorMessage = "Invalid token received"
                    self.showAlert = true
                }
            } catch {
                
                print (error.localizedDescription)
                
                throw StringError(message: "Failed to decode response data")
            }
        
        } catch {
            print (error.localizedDescription)
            throw error
        }
    }

    
    func signInWithGoogle(_ data: SignInWithGoogleData) {
        Task {
            guard let url = URL(string: "http://localhost:8000/google") else {
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

struct RegisterView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        RegisterView(path: $path)
    }
}



//
//
// // Code
//
//import SwiftUI
//
//struct SignUpView: View {
//    @State private var name: String = ""
//    @State private var email: String = ""
//    @State private var password: String = ""
//    @State private var confirmPassword: String = ""
//
//    @State private var isShowingNameError:Bool=false;
//    @State private var isShowingEmailError:Bool=false;
//    @State private var isShowingPasswordError:Bool=false;
//    @State private var isShowingConfirmPasswordError:Bool=false;
//
//
//    var body: some View {
//        VStack {
//            Spacer().frame(height: 20)
//
//            // Title
//            Text("Sign Up")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//
//            Spacer().frame(height: 40)
//
//            // Input Fields
//            VStack(spacing: 20) {
//                CustomTextField(placeholder: "Name", text: $name, isAlert: $isShowingNameError , iconName: "person.fill" , title: "" , message: "")
//                CustomTextField(placeholder: "Email", text: $email, isAlert: $isShowingEmailError ,iconName: "envelope.fill" , title: "Invalid Email" , message: "Please enter a valid email address.")
//                CustomTextField(placeholder: "Password", text: $password, isAlert: $isShowingPasswordError, iconName: "lock.fill", isSecure: true , title: "Invalid Password" , message: "Password should contain at least 8 characters, including one uppercase letter, one lowercase letter, one number, and one special character.")
//                CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isAlert: $isShowingConfirmPasswordError , iconName: "lock.fill", isSecure: true , title: "Invalid Confirm Password" , message: "Confirm password does not match the password.")
//            }
//            .padding(.horizontal, 30)
//
//            Spacer().frame(height: 40)
//
//            // Continue Button
//            Button(action: {
//                // Action for the continue button
//            }) {
//                Text("Continue")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .padding()
//                    .frame(maxWidth: .infinity)
//                    .background(Color.red)
//                    .cornerRadius(20)
//            }
//            .padding(.horizontal, 30)
//
//            Spacer()
//        }
//        .background(Color.purple.edgesIgnoringSafeArea(.all))
//    }
//}
//
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isAlert : Bool
    var iconName: String
    var isSecure: Bool = false
    
    var title : String
    var message: String
    
    var body: some View {
        HStack {
            Image(systemName: iconName)
                .foregroundColor(.black).padding(.leading, 5)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .cornerRadius(5.0)
                    .padding(10)
                    .alert(isPresented: $isAlert) {
                        Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
                    }
                   
            } else {
                TextField(placeholder, text: $text)
                    .cornerRadius(5.0)
                    .padding(10)
                    .alert(isPresented: $isAlert) {
                        Alert(title: Text(title), message: Text(message), dismissButton: .default(Text("OK")))
                    }
            }
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

//struct SignUpView_Previews: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//    }
//}
//
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}



struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                Spacer()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.4))
        .edgesIgnoringSafeArea(.all)
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}



