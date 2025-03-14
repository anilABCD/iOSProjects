//
//  GlobalConstants.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 09/06/24.
//

import Foundation
import SwiftUI

struct Constants {
    
//    static let localhost = "http://192.168.1.5:80"
//    static let localhost = "http://98.80.30.207"
//
    
//    static let serverImageURL = "https://ddt3gc1fx7dtf.cloudfront.net"
    
    static let localhost = "http://192.168.1.5:80"
    static let serverImageURL = "http://192.168.1.5:80/images"
    
//    static let localhost = "http://82.25.105.7"
//    static let serverImageURL = "https://ddt3gc1fx7dtf.cloudfront.net/uploads"
//    

// get from : ifconfig : check all ipaddresses from ifconfig , give this list to chatgpt , chagpt will provide with the ip addressses list . to work on iphone
// prompt : to use by the iPhone device when connected to xcode
//    static let localhost = "http://169.254.80.145:8000"
    
    struct Colors {
        static let primary = Color.orange
        static let background = Color.white
        static let text = Color.black
    }

    struct Strings {
        static let signInTitle = "Sign In"
        static let emailPlaceholder = "Email"
        static let passwordPlaceholder = "Password"
        static let invalidEmailMessage = "Please enter a valid email address."
        static let invalidPasswordMessage = "Please enter a valid password."
        static let submitButtonTitle = "Save"
        static let signUpPrompt = "Create A New Account"
        static let signUpButtonTitle = "Sign Up"
        static let alertMessage = "Incorrect email or password."
    }
    
    struct Dimensions {
        static let cornerRadius: CGFloat = 50
        static let buttonHeight: CGFloat = 50
        static let horizontalPadding: CGFloat = 20
        static let verticalSpacing: CGFloat = 20
    }
    
    struct URLs {
        static let signIn = "https://example.com/auth/login"
        static let signInWithGoogle = "https://example.com/google"
    }
}
