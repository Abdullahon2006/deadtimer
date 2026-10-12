import SwiftUI

struct AtlasHomeView: View {
    @State private var isShowingRegionSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    mapSurface

                    SectionHeading(title: "Downloaded regions", action: "Manage")
                    regionCard

                    SectionHeading(title: "Recent places", action: "See all")
                    recentPlace
                }
                .padding(20)
            }
            .background(MyAtlasTheme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingRegionSheet) {
                RegionDownloadSheet()
                    .presentationDetents([.medium])
            }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("myatlas")
                    .font(.system(size: 36, weight: .black, design: .serif))
                    .foregroundStyle(MyAtlasTheme.ink)
                Text("Your places, kept close.")
                    .font(.subheadline)
                    .foregroundStyle(MyAtlasTheme.moss)
            }
            Spacer()
            Button {
                isShowingRegionSheet = true
            } label: {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.title2)
                    .foregroundStyle(MyAtlasTheme.clay)
            }
            .accessibilityLabel("Download a map region")
        }
    }

    private var mapSurface: some View {
        ZStack(alignment: .bottomLeading) {
            RoundedRectangle(cornerRadius: 18)
                .fill(MyAtlasTheme.mist)
                .frame(height: 248)
                .overlay {
                    Image(systemName: "map.fill")
                        .font(.system(size: 48))
                        .foregroundStyle(MyAtlasTheme.moss.opacity(0.35))
                }
            VStack(alignment: .leading, spacing: 5) {
                Label("Offline atlas", systemImage: "checkmark.shield.fill")
                    .font(.caption.weight(.bold))
                Text("Your downloaded places will appear here")
                    .font(.headline)
            }
            .foregroundStyle(MyAtlasTheme.ink)
            .padding(18)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Offline atlas map. Your downloaded places will appear here.")
    }

    private var regionCard: some View {
        HStack(spacing: 14) {
            Image(systemName: "square.stack.3d.up.fill")
                .font(.title2)
                .foregroundStyle(MyAtlasTheme.clay)
                .frame(width: 42, height: 42)
                .background(MyAtlasTheme.clay.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text("No regions yet")
                    .font(.headline)
                Text("Download a place before you go")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 14))
    }

    private var recentPlace: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.title2)
                .foregroundStyle(MyAtlasTheme.moss)
            VStack(alignment: .leading, spacing: 3) {
                Text("Your first place is waiting")
                    .font(.headline)
                Text("Drop a pin and start the story")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private struct RegionDownloadSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Download your first region")
                    .font(.system(.title2, design: .serif).weight(.bold))
                Text("Map downloads will be stored on this device for use without a connection.")
                    .foregroundStyle(.secondary)
                Spacer()
                Button("Choose a region") {}
                    .buttonStyle(.borderedProminent)
                    .tint(MyAtlasTheme.ink)
            }
            .padding(24)
            .navigationTitle("Offline maps")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}