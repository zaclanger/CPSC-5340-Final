//
//  MainView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/15/24.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    @AppStorage("uid") var userID : String = ""
    
    var body: some View {
        VStack {
            Text("You're logged in! User ID: \(userID)")
            Button (action: {
                do {
                    try Auth.auth().signOut()
                    userID = ""
                } catch {
                    print(error)
                }
            }) {
                Text("Sign Out")
            }
        }
    }
}

#Preview {
    MainView()
}
