import SwiftUI

struct TimerView: View {
    @EnvironmentObject var store: TaskStore
    @State private var selectedTaskId: UUID?
    @State private var isRunning = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    
    var activeTasks: [TaskItem] {
        store.tasks.filter { !$0.isCompleted }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                if activeTasks.isEmpty {
                    Text("No active tasks to track.")
                        .foregroundColor(.secondary)
                } else {
                    Picker("Select Task", selection: $selectedTaskId) {
                        Text("Select a task").tag(UUID?(nil))
                        ForEach(activeTasks) { task in
                            Text(task.title).tag(UUID?(task.id))
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                    .disabled(isRunning)
                    
                    ZStack {
                        Circle()
                            .stroke(lineWidth: 20)
                            .opacity(0.3)
                            .foregroundColor(.indigo)
                        
                        Circle()
                            .trim(from: 0.0, to: 1.0)
                            .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                            .foregroundColor(.indigo)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear(duration: 1), value: elapsedTime)
                        
                        Text(elapsedTime.formattedTime)
                            .font(.system(size: 60, weight: .bold, design: .monospaced))
                    }
                    .frame(width: 250, height: 250)
                    .padding()
                    
                    HStack(spacing: 30) {
                        Button(action: toggleTimer) {
                            Image(systemName: isRunning ? "pause.fill" : "play.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(isRunning ? Color.orange : Color.green)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .disabled(selectedTaskId == nil)
                        
                        Button(action: stopAndSave) {
                            Image(systemName: "stop.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .frame(width: 80, height: 80)
                                .background(Color.red)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                        .disabled(elapsedTime == 0)
                    }
                }
            }
            .padding()
            .navigationTitle("Focus Timer")
        }
    }
    
    private func toggleTimer() {
        if isRunning {
            timer?.invalidate()
            isRunning = false
        } else {
            isRunning = true
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                elapsedTime += 1
            }
        }
    }
    
    private func stopAndSave() {
        timer?.invalidate()
        isRunning = false
        
        if let taskId = selectedTaskId, let task = store.tasks.first(where: { $0.id == taskId }) {
            store.addTimeSpent(to: task, seconds: elapsedTime)
        }
        
        elapsedTime = 0
        selectedTaskId = nil
    }
}
