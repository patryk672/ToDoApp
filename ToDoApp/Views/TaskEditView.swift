//
//  TaskEditView.swift
//  ToDoApp
//
//  Created by Patryk on 11/06/2024.
//

import SwiftUI

struct TaskEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name: String = ""
    @State private var detail: String = ""
    @State private var dueDate: Date = Date()
    @State private var selectedCategory: Category?
    
    var body: some View {
        Form {
            TextField("Task Name", text: $name)
            TextEditor(text: $detail)
            DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
            // Category Picker here
            Button("Save Task") {
                let newTask = Task(context: viewContext)
                newTask.name = name
                newTask.detail = detail
                newTask.dueDate = dueDate
                newTask.category = selectedCategory ?? <#default value#>
                try? viewContext.save()
                presentationMode.wrappedValue.dismiss()
            }
        }
        .navigationBarTitle("New Task")
    }
}
