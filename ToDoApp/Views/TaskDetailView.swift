import SwiftUI

struct TaskDetailView: View {
    @ObservedObject var task: Task
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        Form {
            Section(header: Text("Task Info")) {
                TextField("Name", text: Binding(
                    get: { self.task.name ?? "" },
                    set: { self.task.name = $0 }
                ))
                TextField("Detail", text: Binding(
                    get: { self.task.detail ?? "" },
                    set: { self.task.detail = $0 }
                ))
                Toggle(isOn: Binding(
                    get: { self.task.isCompleted },
                    set: { self.task.isCompleted = $0 }
                )) {
                    Text("Completed")
                }
            }
        }
        .navigationBarTitle(task.name ?? "New Task", displayMode: .inline)
        .navigationBarItems(trailing: Button("Save") {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        })
    }
}
