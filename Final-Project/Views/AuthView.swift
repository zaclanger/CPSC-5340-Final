//
//  AuthView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/14/24.
//

import SwiftUI

struct AuthView: View {
    
    @State private var currentView : String = "login"
    
    @AppStorage("uid") var userID : String = ""
    
    var body: some View {
        if (currentView == "login") {
            LoginView(currentView: $currentView)
        } else {
            RegisterView(currentView: $currentView)
        }
    }
}

#Preview {
    AuthView()
}
