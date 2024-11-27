//
//  MemoryView.swift
//  Final-Project
//
//  Created by Zachary Langer on 11/22/24.
//

import SwiftUI
import PhotosUI

struct MemoryView: View {
    
    @Binding var memory : ExtractedMemoryModel
    @ObservedObject var memApp = MemoryViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            DatePicker("Memory Date", selection: $memory.formattedDate, displayedComponents: .date)
                .onChange(of: memory.formattedDate) {
                    let formatter = ISO8601DateFormatter()
                    formatter.formatOptions = [.withFullDate]
                    
                    memory.dateString = formatter.string(from: memory.formattedDate)
                }
            TextField("Memory Name", text: $memory.title)
                .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
                .font(.system(size: 20))
                .bold()
            TextEditor(text: $memory.body)
                .font(.system(size: 16))
                .scrollContentBackground(.hidden)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
            Button {
                memApp.deleteMemory(memory: memory)
            } label: {
                Text("Delete Memory")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .padding()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    memApp.saveMemory(memory: memory)
                } label: {
                    Text("Save Memory")
                }
            }
        }
    }
}

#Preview {
    MemoryView(memory : .constant(ExtractedMemoryModel(id: "1234", owner: "1234", dateString: "2024-11-24", title: "Test", body: "This is a test memory!")))
}
