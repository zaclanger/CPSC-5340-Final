//
//  ContentView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/14/24.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("uid") var userID : String = ""
    
    var body: some View {
        if (userID != "") {
            MainView()
        } else {
            AuthView()
        }
    }
}

#Preview {
    ContentView()
}
