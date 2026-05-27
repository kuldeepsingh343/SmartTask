import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TaskListView()
                .tabItem {
                    Label("Tasks", systemImage: "checklist")
                }
            
            TimerView()
                .tabItem {
                    Label("Focus Timer", systemImage: "timer")
                }
            
            AnalyticsView()
                .tabItem {
                    Label("Analytics", systemImage: "chart.bar.fill")
                }
        }
        .accentColor(.indigo)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(TaskStore())
    }
}
