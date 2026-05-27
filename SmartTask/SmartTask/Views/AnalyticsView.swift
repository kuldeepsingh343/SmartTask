import SwiftUI

struct AnalyticsView: View {
    @EnvironmentObject var store: TaskStore
    
    var totalTasks: Int { store.tasks.count }
    var completedTasks: Int { store.tasks.filter { $0.isCompleted }.count }
    var totalTimeSpent: TimeInterval {
        store.tasks.reduce(0) { $0 + $1.timeSpent }
    }
    
    var completionRate: Double {
        if totalTasks == 0 { return 0 }
        return Double(completedTasks) / Double(totalTasks)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Summary Cards
                    HStack(spacing: 15) {
                        StatCard(title: "Completed", value: "\(completedTasks)/\(totalTasks)", icon: "checkmark.circle.fill", color: .green)
                        StatCard(title: "Total Time", value: totalTimeSpent.formattedTime, icon: "clock.fill", color: .indigo)
                    }
                    .padding(.horizontal)
                    
                    // Progress Chart (Simulated for iOS 15 support without SwiftCharts)
                    VStack(alignment: .leading) {
                        Text("Task Completion")
                            .font(.headline)
                        
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 20)
                                    .foregroundColor(Color.gray.opacity(0.3))
                                
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(width: geometry.size.width * CGFloat(completionRate), height: 20)
                                    .foregroundColor(.green)
                                    .animation(.spring(), value: completionRate)
                            }
                        }
                        .frame(height: 20)
                        
                        Text("\(Int(completionRate * 100))% of tasks completed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 4)
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    // Detailed List
                    VStack(alignment: .leading) {
                        Text("Time by Task")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(store.tasks.sorted(by: { $0.timeSpent > $1.timeSpent })) { task in
                            if task.timeSpent > 0 {
                                HStack {
                                    Text(task.title)
                                        .lineLimit(1)
                                    Spacer()
                                    Text(task.timeSpent.formattedTime)
                                        .bold()
                                }
                                .padding(.vertical, 8)
                                Divider()
                            }
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Analytics")
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Text(value)
                .font(.title2)
                .bold()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(15)
    }
}
