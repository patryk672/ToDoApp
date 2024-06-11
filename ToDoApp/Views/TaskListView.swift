import SwiftUI

struct TaskListView: View {
    @ObservedObject var category: Category
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest var tasks: FetchedResults<Task>

    @State private var showingAddTask = false
    @State private var showingEditTask = false
    @State private var newTaskName = ""
    @State private var newTaskDetail = ""
    @State private var selectedTask: Task?
    @State private var showingAlert = false
    @State private var alertMessage = ""

    init(category: Category) {
        self.category = category
        _tasks = FetchRequest<Task>(
            entity: Task.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Task.isCompleted, ascending: true)],
            predicate: NSPredicate(format: "category == %@", category)
        )
    }

    var body: some View {
        List {
            ForEach(tasks) { task in
                HStack {
                    Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                        .onTapGesture {
                            toggleTaskCompletion(task: task)
                        }
                    NavigationLink(destination: TaskDetailView(task: task)) {
                        Text(task.name ?? "Unnamed")
                            .strikethrough(task.isCompleted, color: .black)
                    }
                }
                .contextMenu {
                    Button(action: {
                        selectedTask = task
                        newTaskName = task.name ?? ""
                        newTaskDetail = task.detail ?? ""
                        showingEditTask = true
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                    Button(action: {
                        deleteTask(task: task)
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: deleteTasks)
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid Input"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $showingAddTask) {
            VStack {
                Text("New Task")
                    .font(.headline)
                TextField("Task Name", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Task Detail", text: $newTaskDetail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Add") {
                    if newTaskName.isEmpty {
                        alertMessage = "Task name cannot be empty"
                        showingAlert = true
                    } else {
                        addTask()
                        showingAddTask = false
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showingEditTask) {
            VStack {
                Text("Edit Task")
                    .font(.headline)
                TextField("Task Name", text: $newTaskName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                TextField("Task Detail", text: $newTaskDetail)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save") {
                    if newTaskName.isEmpty {
                        alertMessage = "Task name cannot be empty"
                        showingAlert = true
                    } else {
                        editTask()
                        showingEditTask = false
                    }
                }
                .padding()
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle(category.name ?? "Unnamed")
        .navigationBarItems(trailing: Button(action: { showingAddTask = true }) {
            Label("Add Task", systemImage: "plus")
        })
    }

    private func addTask() {
        withAnimation {
            let newTask = Task(context: viewContext)
            newTask.name = newTaskName
            newTask.detail = newTaskDetail
            newTask.isCompleted = false
            newTask.category = category

            do {
                try viewContext.save()
                newTaskName = ""
                newTaskDetail = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func editTask() {
        if let task = selectedTask {
            task.name = newTaskName
            task.detail = newTaskDetail
            do {
                try viewContext.save()
                newTaskName = ""
                newTaskDetail = ""
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func toggleTaskCompletion(task: Task) {
        withAnimation {
            task.isCompleted.toggle()
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteTasks(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteTask(task: Task) {
        withAnimation {
            viewContext.delete(task)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
