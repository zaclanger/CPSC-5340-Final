//
//  MemoryListView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/23/24.
//

import SwiftUI
import FirebaseAuth

struct MemoryListView: View {
    
    @AppStorage("uid") var userID = ""
    
    @ObservedObject var memApp = MemoryViewModel()
    @State var memory = ExtractedMemoryModel(owner: "", dateString: "2024-11-25", title: "", body: "")
    
    let orderOptions = ["descending", "ascending"]
    @State var order = "descending"
    
    var body: some View {
        NavigationStack {
            List {
                ForEach($memApp.extractedMemories) { $memory in
                    NavigationLink {
                        MemoryView(memory: $memory)
                    } label: {
                        Text("\(memory.dateString) - \(memory.title)")
                    }
                }
                Section {
                    NavigationLink {
                        MemoryView(memory: $memory)
                    } label: {
                        Text("New Memory")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Picker("Order by", selection: $order) {
                        ForEach(orderOptions, id: \.self) {
                            Text("Order by date \($0)")
                        }
                    }
                    .onChange(of: order) {
                        memApp.fetchMemories(order)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
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
            .onAppear {
                memApp.fetchMemories(order)
            }
            .refreshable {
                memApp.fetchMemories(order)
            }
        }
    }
}

#Preview {
    MemoryListView()
}
