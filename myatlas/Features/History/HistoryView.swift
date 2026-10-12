import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var atlas: AtlasViewModel

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 5) {
                        Text("History")
                            .font(.system(size: 28, weight: .bold, design: .serif))
                        Text("A quiet record of where life took you.")
                            .foregroundStyle(MyAtlasTheme.moss)
                    }

                    SectionHeading(title: "Timeline", action: nil)
                    if atlas.recentPlaces.isEmpty {
                        ContentUnavailableView(
                            "No places recorded",
                            systemImage: "figure.walk.motion",
                            description: Text("Places you save will gather here in order of your travels.")
                        )
                        .frame(maxWidth: .infinity)
                    } else {
                        ForEach(atlas.recentPlaces) { place in
                            PlaceHistoryRow(place: place)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
            .background(MyAtlasTheme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
        }
    }

    private struct PlaceHistoryRow: View {
        let place: Place

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                VStack(spacing: 4) {
                    Circle().fill(MyAtlasTheme.clay).frame(width: 8, height: 8)
                    Rectangle().fill(MyAtlasTheme.mist).frame(width: 2, height: 48)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name).font(.subheadline.weight(.semibold))
                    Text(place.subtitle).font(.subheadline).foregroundStyle(.secondary)
                    if let note = place.note {
                        Text(note).font(.subheadline).foregroundStyle(MyAtlasTheme.moss)
                    }
                    Text(place.visitedAt, format: .dateTime.month(.wide).day().year())
                        .font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
            }
        }
    }
}