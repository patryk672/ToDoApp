//
//  AddCategoryView.swift
//  ToDoApp
//
//  Created by Patryk on 11/06/2024.
//

import SwiftUI

struct AddCategoryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Category Name", text: $name)
                Button("Save") {
                    let newCategory = Category(context: viewContext)
                    newCategory.name = name

                    do {
                        try viewContext.save()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        // Handle the error appropriately
                    }
                }
            }
            .navigationTitle("Add Category")
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
