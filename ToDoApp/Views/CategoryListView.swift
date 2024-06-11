import SwiftUI
import CoreData

struct CategoryListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: [])
    var categories: FetchedResults<Category>

    var body: some View {
        NavigationView {
            List {
                ForEach(categories) { category in
                    NavigationLink(destination: TaskListView(category: category)) {
                        Text(category.name ?? "Unnamed")
                    }
                }
                .onDelete(perform: deleteCategories)
            }
            .navigationBarTitle("Categories")
            .navigationBarItems(trailing: Button(action: addCategory) {
                Label("Add Category", systemImage: "plus")
            })
        }
    }

    private func addCategory() {
        withAnimation {
            let newCategory = Category(context: viewContext)
            newCategory.name = "New Category"

            do {
                try viewContext.save()
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
