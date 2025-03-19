
import SwiftUI

import GoogleSignInSwift

import GoogleSignIn

struct LoginSocialView: View {
    
    @Binding var path :[MyNavigation<String>]
    @EnvironmentObject private var tokenManger : TokenManager
  
    @State private var email: String = "Anil@gmail.com"
    @State private var password: String = "Password@123"
    
    @State private var showAlert: Bool = false
    @State private var token: String?
    
  
    @State private var isShowingEmailError:Bool=false;
    @State private var isShowingPasswordError:Bool=false;


   
    func handleSignInGoogleButton() {
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
                   let idToken = user.idToken?.tokenString
                   let fullName = user.profile?.name
                   let email = user.profile?.email
                   
                   // Handle the signed-in user's information
                   print("User signed in: \(fullName ?? "No Name"), email: \(email ?? "No Email") , idToken : \(String(describing: idToken))")
                   
                   
                   if let googleToken = idToken {
                       let signInWithGoogleData = SignInWithSocialLoginData(token: googleToken )
                       
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
            
            
//            SkeletonLoadingExampleView Testing Example ...
//            SkeletonLoadingExampleView()
//            This is sepeare example ...

            VStack {
                
                // Title
                Text("Sign In")
                
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.vertical)
                
                Spacer().frame(height: 40)
                
//                // Input Fields
//                VStack(spacing: 20) {
//
//                    CustomTextField(placeholder: "Email", text: $email, isAlert: $isShowingEmailError ,iconName: "envelope.fill" , title: "Invalid Email" , message: "Please enter a valid email address.")
//                    CustomTextField(placeholder: "Password", text: $password, isAlert: $isShowingPasswordError, iconName: "lock.fill", isSecure: true , title: "Invalid Password" , message: "Please Enter Password.")
//
//
//                } .padding(.horizontal, 30)
                
                VStack{
//                    Button(action: {
//                        // Handle signup button action here
//
//                        validateInput()
//
//                        //                let signUpData = SignUpData(name: name, email: email, password: password, passwordConfirm: confirmPassword, technology: ["#Swift UI"])
//                        //                signUp(signUpData)
//                    }) {
//                        Text("Submit")
//                            .frame(minWidth: 0, maxWidth: .infinity)
//                            .frame(height: 50)
//                            .foregroundColor(.black)
//                            .font(.system(size: 18, weight: .bold))
//                            .background(Color.orange)
//                            .cornerRadius(50)
//                    }
//                    .padding(.horizontal, 20)
//                    .alert(isPresented: $showAlert) {
//                        Alert(title: Text(""), message: Text("Incorrect email or password."), dismissButton: .default(Text("OK")))
//                    }
//
                    
                    HStack(spacing: 4) {
                               Button(action: {
                                   handleSignInGoogleButton()
                               }) {
                                   HStack {
                                       Image("googleIcon") // Replace with your Google icon image
                                           .resizable()
                                           .frame(width: 40, height: 40)
                                       
                                       Text("Sign In With Google")
                                   }
                               }

                              
                    }
                    .padding(6)
                           .background(Color.white) // Background color of the capsule
                           .clipShape(Capsule()) // Clip the HStack into a capsule shape
                           .overlay(
                               Capsule()
                                   .stroke(Color.gray, lineWidth: 1) // Border color and width
                           )
                           .shadow(radius: 5) // Optional: add a shadow for better appearance

                    
                    
//                    // Additional Options
//                    HStack {
//                        Text("Create A New Account")
//                        Button(action: {
//                            path.append(MyNavigation<String>(appView: .signUp, params: Params<String>(data: "")))
//                        }) {
//                            Text("Sign Up")
//                                .foregroundColor(.blue)
//                        }
//                    }
//                    .padding(.top, 20)
                    
                    Spacer()
                }.frame(alignment: .topLeading )
                    .padding()
                
                
                
                
                Spacer( )
            }.frame(maxWidth:.infinity).background(.white).cornerRadius(40, corners: [.topLeft, .topRight]).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).background(.orange)
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/).background(.orange)
    }

    
    private func validateInput() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            resetValidationFlags()
            
            print(isShowingEmailError , isShowingPasswordError , showAlert)
            
        }
        
       
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
           
            resetValidationFlags()
            
            validateEmail()
            validatePassword()
         
            
            if isShowingEmailError || isShowingPasswordError  {
                // Perform signup
                showAlert = true // For demo purpose
                
                
            }
            else{
                
                let signInData = SignInData(email: email, password: password)
        
                signIn(signInData)
            }
            
            
            print(isShowingEmailError , isShowingPasswordError , showAlert)
            
            
        }
    }
    
    private func resetValidationFlags() {
           isShowingEmailError = false
           isShowingPasswordError = false
        
        
        showAlert=false;
       }
       
    
    func signIn(_ data: SignInData) {
        Task {
            guard let url = URL(string: "\(tokenManger.localhost)/auth/login") else {
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
         
                    if let tokenId = decodedResponse.token {
                        
                          DispatchQueue.main.async {
                              
                              self.token = tokenId;
                              
                              tokenManger.updateAccessToken( token: self.token ?? "" , userId: decodedResponse.data?.user?.id ?? "" , email: decodedResponse.data?.user?.email ?? "", name: decodedResponse.data?.user?.name ?? "", photo: decodedResponse.data?.user?.photo ?? "",
                                                             technologies: decodedResponse.data?.user?.technologies ?? "", hobbies: decodedResponse.data?.user?.hobbies ?? "" , bio: decodedResponse.data?.user?.bio ?? "", jobRole: decodedResponse.data?.user?  .jobRole ?? "" ,
                                                                dob: decodedResponse.data?.user?.dob ?? "" ,
                                                             smoking: decodedResponse.data?.user?.smoking ?? ""  ,
                                                             drinking: decodedResponse.data?.user?.drinking ?? "" ,
                                                             photo1: decodedResponse.data?.user?.photo1 ?? "" ,
                                                             photo2: decodedResponse.data?.user?.photo2 ?? "" ,
                                                             photo3: decodedResponse.data?.user?.photo3 ??  "" ,
                                                             photo4: decodedResponse.data?.user?.photo4 ??  "", gender: decodedResponse.data?.user?.gender ??  ""
                              )
                              
                              tokenManger.shouldRefecthUnreadCount = UUID()
                              
                              
                              print("Token: \(self.token ?? "No token received")")
                              print("Name: \(decodedResponse.data?.user?.name ?? "No token received")")
                              print("Email: \(decodedResponse.data?.user?.email ?? "No token received")")
                              // Handle successful signup, maybe navigate to another view
                          }
                    } else {
                        print("No Token")
                    }
                   
               
                } else {
                    // Show error alert
                    DispatchQueue.main.async {
                        showAlert = true
                    }
                    print("Invalid response from server")
                }
            }.resume()
        }
        
        
        
    }
    
    
    func signInWithGoogle(_ data: SignInWithSocialLoginData) {
        Task {
            guard let url = URL(string: "\(tokenManger.localhost)/google") else {
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
         
                    if let tokenId = decodedResponse.token {
                        
                          DispatchQueue.main.async {
                              
                              self.token = tokenId;
                              
                              tokenManger.updateAccessToken( token: self.token ?? "" , userId: decodedResponse.data?.user?.id ?? "", email: decodedResponse.data?.user?.email ?? "", name: decodedResponse.data?.user?.name ?? "", photo: decodedResponse.data?.user?.photo ?? "",
                                                             technologies: decodedResponse.data?.user?.technologies ?? "" , hobbies: decodedResponse.data?.user?.hobbies ?? "", bio: decodedResponse.data?.user?.bio ?? "", jobRole: decodedResponse.data?.user?.jobRole ?? ""  ,
                                                             dob: decodedResponse.data?.user?.dob ?? "" ,
                                                          smoking: decodedResponse.data?.user?.smoking ?? ""  ,
                                                          drinking: decodedResponse.data?.user?.drinking ?? "" ,
                                                          photo1: decodedResponse.data?.user?.photo1 ?? "" ,
                                                          photo2: decodedResponse.data?.user?.photo2 ?? "" ,
                                                          photo3: decodedResponse.data?.user?.photo3 ??  "" ,
                                                          photo4: decodedResponse.data?.user?.photo4 ??  "" ,
                                                          gender : decodedResponse.data?.user?.gender ??  "" 
                           )
                              
                              tokenManger.shouldRefecthUnreadCount = UUID()
                            
                              print("Token: \(self.token ?? "No token received")")
                              print("Name: \(decodedResponse.data?.user?.name ?? "No token received")")
                              print("Email: \(decodedResponse.data?.user?.email ?? "No token received")")
                              
//                              print (tokenManger.dob , tokenManger.drinking, tokenManger.smoking)
                              // Handle successful signup, maybe navigate to another view
                          }
                    } else {
                        print("No Token")
                    }
                   
               
                } else {
                    // Show error alert
                    DispatchQueue.main.async {
                        showAlert = true
                    }
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
        
           isShowingPasswordError = ( password == "" )
       }
       
     
    
 
}

struct LoginSocialView_Previews: PreviewProvider {
    @State static var path: [MyNavigation<String>] = [] // Define path as a static state variable
       
    static var previews: some View {
        LoginSocialView(path: $path)
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
