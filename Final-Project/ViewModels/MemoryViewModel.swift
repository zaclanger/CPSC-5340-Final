//
//  MemoryViewModel.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/23/24.
//

import Foundation
import SwiftUI
import FirebaseCore
import FirebaseFirestore

class MemoryViewModel : ObservableObject {
    
    @Published var memories = [MemoryModel]()
    @Published var extractedMemories = [ExtractedMemoryModel]()
    @AppStorage("uid") var userID = ""
    
    let db = Firestore.firestore()
    
    func fetchMemories(_ order: String) {
        // Initialize memories/extractedMemories
        self.memories.removeAll()
        self.extractedMemories.removeAll()
        
        let desc = (order == "ascending") ? false : true
        
        // Query the database for all documents where the user is the owner
        db.collection("memories").order(by: "dateString", descending: desc).whereField("owner", isEqualTo: userID).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    do {
                        let formatter = ISO8601DateFormatter()
                        formatter.formatOptions = [.withFullDate]
                        
                        // Build the memory array, maybe unnecessary?
                        let memory = try document.data(as: MemoryModel.self)
                        self.memories.append(try document.data(as: MemoryModel.self))

                        // Build the extractedMemory array (with Date() from dateString)
                        var extractedMemory = ExtractedMemoryModel(id: memory.id, owner: memory.owner, dateString: memory.dateString, title: memory.title, body: memory.body)
                        extractedMemory.formattedDate = formatter.date(from: extractedMemory.dateString) ?? Date()
                        self.extractedMemories.append(extractedMemory)
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    func saveMemory(memory: ExtractedMemoryModel) {
        if let id = memory.id {
            // Edit
            if !memory.title.isEmpty || !memory.body.isEmpty {
                let docRef = db.collection("memories").document(id)
                
                docRef.updateData([
                    "dateString": memory.dateString,
                    "title": memory.title,
                    "body": memory.body
                ]) { err in
                    if let err = err {
                        print("Error updating: \(err)")
                    }
                }
            }
        } else {
            // Add
            if !memory.title.isEmpty || !memory.body.isEmpty {
                var ref : DocumentReference? = nil
                ref = db.collection("memories").addDocument(data: [
                    "owner": userID,
                    "dateString": memory.dateString,
                    "title": memory.title,
                    "body": memory.body
                ]) { err in
                    if let err = err {
                        print("Error adding: \(err)")
                    } else {
                        print("New Document: \(ref!.documentID)")
                    }
                }
            }
        }
    }
    
    func deleteMemory(memory: ExtractedMemoryModel) {
        db.collection("memories").whereField("id", isEqualTo: memory.id!).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    document.reference.delete()
                }
            }
        }
    }
}
