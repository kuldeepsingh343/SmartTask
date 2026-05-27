import Foundation

struct TaskItem: Identifiable, Codable {
    var id: UUID = UUID()
    var title: String
    var description: String
    var dueDate: Date?
    var isCompleted: Bool = false
    var timeSpent: TimeInterval = 0 // in seconds
    var priority: Priority = .medium
    
    enum Priority: String, Codable, CaseIterable {
        case low = "Low"
        case medium = "Medium"
        case high = "High"
    }
}

class TaskStore: ObservableObject {
    @Published var tasks: [TaskItem] = [] {
        didSet {
            saveTasks()
        }
    }
    
    init() {
        loadTasks()
    }
    
    // MARK: - CRUD Operations
    func addTask(title: String, description: String, dueDate: Date?, priority: TaskItem.Priority) {
        let newTask = TaskItem(title: title, description: description, dueDate: dueDate, priority: priority)
        tasks.append(newTask)
    }
    
    func updateTask(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
        }
    }
    
    func toggleCompletion(for task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func addTimeSpent(to task: TaskItem, seconds: TimeInterval) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].timeSpent += seconds
        }
    }
    
    // MARK: - Persistence
    private let saveKey = "SmartTaskData"
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: saveKey)
        }
    }
    
    private func loadTasks() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let decoded = try? JSONDecoder().decode([TaskItem].self, from: data) {
            tasks = decoded
        } else {
            // Provide a sample task for testing if empty
            tasks = [
                TaskItem(title: "Explore SmartTask", description: "Master the patterns of time and productivity.", dueDate: Date().addingTimeInterval(86400), priority: .high)
            ]
        }
    }
}
