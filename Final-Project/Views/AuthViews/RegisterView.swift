//
//  AuthenticateView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/14/24.
//

import SwiftUI

struct RegisterView: View {
    
    @ObservedObject var authVM : AuthenticationViewModel = AuthenticationViewModel()

    @State var email : String = ""
    @State var password : String = ""
    @State var confirmpassword : String = ""
    @State var errorMessage : String = "Email already in use"
    @State var errorShown : Bool = false
    
    @AppStorage("uid") var userID : String = ""
    
    @Binding var currentView : String
    
    
    var registerButtonEnabled : Bool {
        !([email, password, confirmpassword].contains(where: \.isEmpty) || !authVM.passwordIsValid(password) || password != confirmpassword || !authVM.emailIsValid(email))
    }
        
    var body: some View {
        
        VStack(alignment: .leading) {
            VStack {
                Spacer()
                TextField("email", text: $email)
                    .textInputAutocapitalization(.never)
                    .padding(10)
                    .overlay {
                        if (email == "") {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        }
                    }
                    .padding(.horizontal)
                SecureField("password", text: $password)
                    .padding(10)
                    .overlay {
                        if (password == "") {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        } else if (authVM.passwordIsValid(password)){
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 2)
                        }
                    }
                    .padding(.horizontal)
                SecureField("confirm password", text: $confirmpassword)
                    .padding(10)
                    .overlay {
                        if (confirmpassword == "") {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 2)
                        }
                        else if (confirmpassword == password) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.red, lineWidth: 2)
                        }
                    }
                    .padding(.horizontal)
                Spacer()
            }
            VStack(spacing: 15) {
                if (errorShown) {
                    Text(errorMessage)
                }
                if (registerButtonEnabled) {
                    Button(action: {
                        print("Button Pressed")
                        authVM.sendRegister(email: email, password: password)
                        errorShown = true
                    }) {
                        Text("Create Account")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                            .fill(.blue)
                    }
                } else {
                    Button {
                        print("Button Pressed Invalid")
                        if (!authVM.passwordIsValid(password)) {
                            errorMessage = "Password must be 6 characters, have one capital letter, and have one special character"
                        } else if (password != confirmpassword) {
                            errorMessage = "Passwords do not match"
                        } else if (password == "" || confirmpassword == "") {
                            errorMessage = "Please enter password"
                        } else if (email == "") {
                            errorMessage = "Please enter username"
                        } else if (!authVM.emailIsValid(email)) {
                            errorMessage = "Invalid email address"
                        } else {
                            errorMessage = "Unknown error!"
                        }
                        errorShown = true
                    } label: {
                        Text("Create Account")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.blue)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.blue, lineWidth: 2)
                            .fill(.white)
                    }
                }
                Divider()
                Button(action: {
                    print("Login Pressed")
                    self.currentView = "login"
                }) {
                    Text("Already have an account?")
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 50)
        }
    }
    
}
