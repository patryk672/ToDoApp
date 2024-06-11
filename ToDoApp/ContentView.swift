import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: [])
    var categories: FetchedResults<Category>

    @State private var showingAddCategory = false
    @State private var showingEditCategory = false
    @State private var newCategoryName = ""
    @State private var selectedCategory: Category?
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationView {
            VStack {
                Image("todo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 80)

                List {
                    ForEach(categories) { category in
                        NavigationLink(destination: TaskListView(category: category)) {
                            Text(category.name ?? "Unnamed")
                        }
                        .contextMenu {
                            Button(action: {
                                selectedCategory = category
                                newCategoryName = category.name ?? ""
                                showingEditCategory = true
                            }) {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                    .onDelete(perform: deleteCategories)
                }
                .navigationBarTitle("Categories")
                .navigationBarItems(trailing: Button(action: { showingAddCategory = true }) {
                    Label("Add Category", systemImage: "plus")
                })
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingAddCategory) {
            VStack {
                Text("New Category")
                    .font(.headline)
                TextField("Category Name", text: $newCategoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Add") {
                    if newCategoryName.isEmpty {
                        alertMessage = "Category name cannot be empty"
                        showingAlert = true
                    } else {
                        addCategory()
                        showingAddCategory = false
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showingEditCategory) {
            VStack {
                Text("Edit Category")
                    .font(.headline)
                TextField("Category Name", text: $newCategoryName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save") {
                    if newCategoryName.isEmpty {
                        alertMessage = "Category name cannot be empty"
                        showingAlert = true
                    } else {
                        editCategory()
                        showingEditCategory = false
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
    }

    private func addCategory() {
        withAnimation {
            let newCategory = Category(context: viewContext)
            newCategory.name = newCategoryName

            do {
                try viewContext.save()
                newCategoryName = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func editCategory() {
        if let category = selectedCategory {
            category.name = newCategoryName
            do {
                try viewContext.save()
                newCategoryName = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteCategories(offsets: IndexSet) {
        withAnimation {
            offsets.map { categories[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
