import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AtlasHomeView()
                .tabItem {
                    Label("Atlas", systemImage: "map")
                }

            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
        }
        .tint(MyAtlasTheme.ink)
    }
}

#Preview {
    ContentView()
        .environmentObject(AtlasViewModel())
}