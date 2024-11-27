//
//  AuthenticateView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/14/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email : String = ""
    @State var password : String = ""
    @State var errorMessage : String = ""
    @State var errorShown : Bool = false
    
    @AppStorage("uid") var userID : String = ""
    
    @Binding var currentView : String
    
    @ObservedObject var authVM : AuthenticationViewModel = AuthenticationViewModel()
    
    var signInButtonEnabled : Bool {
        !([email, password].contains(where: \.isEmpty) || !authVM.emailIsValid(email))
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
                        } else {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 2)
                        }
                    }
                    .padding(.horizontal)
                Spacer()
            }
            VStack(spacing: 15) {
                if (errorShown) {
                    Text(errorMessage)
                }
                if (signInButtonEnabled) {
                    Button(action: {
                        print("Sign In Pressed")
                        if (!authVM.sendLogin(email: email, password: password)) {
                            errorMessage = "User not found"
                            errorShown = true
                        }
                    }) {
                        Text("Sign In")
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
                        print("Sign In Invalid")
                        if (email == "" && password == "") {
                            errorMessage = "Please enter username and password"
                        } else if (email == "") {
                            errorMessage = "Please enter username"
                        } else if (password == "") {
                            errorMessage = "Please enter password"
                        } else if (!authVM.emailIsValid(email)) {
                            errorMessage = "Invalid email address"
                        } else {
                            errorMessage = "Unknown Error"
                        }
                        errorShown = true
                    } label: {
                        Text("Sign In")
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
                    print("Register Pressed")
                    self.currentView = "register"
                }) {
                    Text("Create an Account")
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 50)
        }
    }
}
