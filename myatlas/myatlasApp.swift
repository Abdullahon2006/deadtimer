import SwiftUI

@main
struct MyAtlasApp: App {
    @StateObject private var atlas = AtlasViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(atlas)
        }
    }
}