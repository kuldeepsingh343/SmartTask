import SwiftUI

struct TaskListView: View {
    @EnvironmentObject var store: TaskStore
    @State private var showingAddTask = false
    @State private var filter: FilterType = .all
    
    enum FilterType: String, CaseIterable {
        case all = "All"
        case active = "Active"
        case completed = "Completed"
    }
    
    var filteredTasks: [TaskItem] {
        switch filter {
        case .all:
            return store.tasks
        case .active:
            return store.tasks.filter { !$0.isCompleted }
        case .completed:
            return store.tasks.filter { $0.isCompleted }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Filter", selection: $filter) {
                    ForEach(FilterType.allCases, id: \.self) { filterType in
                        Text(filterType.rawValue).tag(filterType)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List {
                    ForEach(filteredTasks) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            TaskRowView(task: task)
                        }
                    }
                    .onDelete(perform: store.deleteTask)
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Smart Tasks")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTask = true }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showingAddTask) {
                AddTaskView()
            }
        }
    }
}

struct TaskRowView: View {
    @EnvironmentObject var store: TaskStore
    let task: TaskItem
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation {
                    store.toggleCompletion(for: task)
                }
            }) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(BorderlessButtonStyle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isCompleted)
                    .foregroundColor(task.isCompleted ? .gray : .primary)
                
                if let dueDate = task.dueDate {
                    Text("Due: \(dueDate, formatter: itemFormatter)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            Text(task.priority.rawValue.prefix(1))
                .font(.caption2).bold()
                .padding(6)
                .background(priorityColor.opacity(0.2))
                .foregroundColor(priorityColor)
                .clipShape(Circle())
        }
        .padding(.vertical, 4)
    }
    
    var priorityColor: Color {
        switch task.priority {
        case .low: return .blue
        case .medium: return .orange
        case .high: return .red
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
