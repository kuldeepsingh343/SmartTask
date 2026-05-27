import SwiftUI

@main
struct SmartTaskApp: App {
    // We will use @StateObject to hold our main data store.
    @StateObject private var store = TaskStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .preferredColorScheme(.dark)
        }
    }
}
