import SwiftUI

struct AddTaskView: View {
    @EnvironmentObject var store: TaskStore
    @Environment(\.presentationMode) var presentationMode
    
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var priority: TaskItem.Priority = .medium
    @State private var hasDueDate = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Task Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section {
                    Picker("Priority", selection: $priority) {
                        ForEach(TaskItem.Priority.allCases, id: \.self) { p in
                            Text(p.rawValue).tag(p)
                        }
                    }
                    
                    Toggle("Set Due Date", isOn: $hasDueDate)
                    if hasDueDate {
                        DatePicker("Date", selection: $dueDate, displayedComponents: .date)
                    }
                }
            }
            .navigationTitle("New Task")
            .navigationBarItems(
                leading: Button("Cancel") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Save") {
                    store.addTask(title: title,
                                  description: description,
                                  dueDate: hasDueDate ? dueDate : nil,
                                  priority: priority)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(title.isEmpty)
            )
        }
    }
}
