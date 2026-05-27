import SwiftUI

struct TaskDetailView: View {
    @EnvironmentObject var store: TaskStore
    @Environment(\.presentationMode) var presentationMode
    
    @State var task: TaskItem
    @State private var isEditing = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isEditing {
                    TextField("Title", text: $task.title)
                        .font(.title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextEditor(text: $task.description)
                        .frame(minHeight: 150)
                        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary, lineWidth: 1))
                } else {
                    Text(task.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(task.description)
                        .font(.body)
                }
                
                HStack {
                    Label("\(task.timeSpent.formattedTime)", systemImage: "clock.fill")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Spacer()
                    
                    if let due = task.dueDate {
                        Label("\(due, formatter: detailFormatter)", systemImage: "calendar")
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    if isEditing {
                        store.updateTask(task)
                    }
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
        }
    }
}

private let detailFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

extension TimeInterval {
    var formattedTime: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        if hours > 0 {
            return String(format: "%02i:%02i:%02i", hours, minutes, seconds)
        }
        return String(format: "%02i:%02i", minutes, seconds)
    }
}
