//
//  MemoryModel.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/22/24.
//

import Foundation
import FirebaseFirestore

struct MemoryModel : Codable, Identifiable {
    
    @DocumentID var id : String?
    var owner : String
    var dateString : String
    var title : String
    var body : String
    
}
