//
//  GlobalConstants.swift
//  DatingAppScreens
//
//  Created by Anil Kumar Potlapally on 09/06/24.
//

import Foundation
import SwiftUI

struct Constants {
    
    static let localhost = "http://localhost:8000"
    
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
        static let submitButtonTitle = "Submit"
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
