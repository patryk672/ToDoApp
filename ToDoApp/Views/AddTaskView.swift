//
//  AddTaskView.swift
//  ToDoApp
//
//  Created by Patryk on 11/06/2024.
//

import SwiftUI

struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    var category: Category

    @State private var name = ""
    @State private var detail = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $name)
                TextField("Task Detail", text: $detail)
                Button("Save") {
                    let newTask = Task(context: viewContext)
                    newTask.name = name
                    newTask.detail = detail
                    newTask.category = category

                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // Handle the error appropriately
                    }
                }
            }
            .navigationTitle("Add Task")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
