//
//  AuthenticationViewModel.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/14/24.
//

import Foundation
import SwiftUI
import FirebaseAuth

enum AuthState {
    case unauthenticated
    case authenticated
}

@MainActor
class AuthenticationViewModel : ObservableObject {
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var authStatus : AuthState = .unauthenticated
    @Published var errorMessage : String = ""
    
    @AppStorage("uid") var userID = ""

    func sendLogin(email: String, password: String) -> Bool {
                
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error: \(error)")
                print("LocalizedDescription: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                print("Error Message: \(self.errorMessage)")
                self.authStatus = .unauthenticated
                self.userID = ""
            }
            
            if let authResult = result {
                print(authResult.user.uid)
                self.errorMessage = ""
                self.userID = authResult.user.uid
                self.authStatus = .authenticated
            }
        }
        return (self.errorMessage == "")
    }
    
    func sendRegister(email: String, password: String) {
                        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error: \(error)")
                print("LocalizedDescription: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                print("Error Message: \(self.errorMessage)")
                self.userID = ""
            }
            
            if let authResult = result {
                print(authResult.user.uid)
                self.errorMessage = ""
                self.userID = authResult.user.uid
            }
        }
    }
    
    func signOut() {
        
        self.errorMessage = ""
        
        do {
            try Auth.auth().signOut()
            self.userID = ""
        } catch {
            print(error)
            self.errorMessage = error.localizedDescription
        }
    }
    
    func passwordIsValid(_ password: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[A-Z]).{6,}$")
        return regex.evaluate(with: password)
    }
    
    func emailIsValid(_ email: String) -> Bool {
        let regex = NSPredicate(format: "SELF MATCHES %@", "^[a-zA-Z0-9_.±]+@[a-zA-Z0-9-]+.[a-zA-Z0-9-.]+$")
        return regex.evaluate(with: email)
    }
    
}
