import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("History")
                            .font(.system(size: 36, weight: .black, design: .serif))
                        Text("A quiet record of where life took you.")
                            .foregroundStyle(MyAtlasTheme.moss)
                    }

                    SectionHeading(title: "Timeline", action: nil)
                    ContentUnavailableView(
                        "No places recorded",
                        systemImage: "figure.walk.motion",
                        description: Text("Places you save will gather here in order of your travels.")
                    )
                    .frame(maxWidth: .infinity)
                }
                .padding(20)
            }
            .background(MyAtlasTheme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }
}