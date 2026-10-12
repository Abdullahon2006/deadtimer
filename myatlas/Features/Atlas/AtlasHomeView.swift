import SwiftUI

struct AtlasHomeView: View {
    @EnvironmentObject private var atlas: AtlasViewModel
    @State private var isShowingRegionSheet = false
    @State private var isShowingPlaceSheet = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    mapSurface
                    SectionHeading(title: "Downloaded regions", action: "Manage")
                    regionCard
                    SectionHeading(title: "Recent places", action: "See all")
                    recentPlaces
                }
                .padding(20)
            }
            .background(MyAtlasTheme.paper.ignoresSafeArea())
            .navigationBarHidden(true)
            .sheet(isPresented: $isShowingRegionSheet) {
                RegionDownloadSheet()
                    .presentationDetents([.medium, .large])
            }
            .sheet(isPresented: $isShowingPlaceSheet) {
                AddPlaceSheet()
                    .presentationDetents([.medium, .large])
            }
        }
    }

    private var header: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("myatlas")
                    .font(.system(size: 36, weight: .black, design: .serif))
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
                Text("\(atlas.downloadedRegions.count) region\(atlas.downloadedRegions.count == 1 ? "" : "s") ready offline")
                    .font(.headline)
            }
            .foregroundStyle(MyAtlasTheme.ink)
            .padding(18)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Offline atlas map. \(atlas.downloadedRegions.count) regions ready offline.")
    }

    private var regionCard: some View {
        Group {
            if atlas.regions.isEmpty {
                Label("Download a place before you go", systemImage: "square.stack.3d.up")
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 0) {
                    ForEach(atlas.regions) { region in
                        RegionRow(region: region)
                        if region.id != atlas.regions.last?.id { Divider().padding(.leading, 58) }
                    }
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.62), in: RoundedRectangle(cornerRadius: 14))
    }

    private var recentPlaces: some View {
        VStack(alignment: .leading, spacing: 14) {
            ForEach(atlas.recentPlaces.prefix(3)) { place in
                PlaceRow(place: place)
            }
            Button {
                isShowingPlaceSheet = true
            } label: {
                Label("Save a place", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundStyle(MyAtlasTheme.clay)
            }
            .accessibilityIdentifier("save-place-button")
        }
    }
}

private struct RegionRow: View {
    @EnvironmentObject private var atlas: AtlasViewModel
    let region: AtlasRegion

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "square.stack.3d.up.fill")
                .foregroundStyle(MyAtlasTheme.clay)
                .frame(width: 42, height: 42)
                .background(MyAtlasTheme.clay.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
            VStack(alignment: .leading, spacing: 3) {
                Text(region.name).font(.headline)
                Text(region.downloadState.label)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if case .downloading(let progress) = region.downloadState {
                ProgressView(value: progress).frame(width: 48)
            } else if case .available = region.downloadState {
                Button("Download") { atlas.download(region: region) }
                    .font(.caption.weight(.bold))
                    .buttonStyle(.bordered)
            } else {
                Image(systemName: "checkmark.circle.fill").foregroundStyle(MyAtlasTheme.moss)
            }
        }
    }
}

private struct PlaceRow: View {
    let place: Place

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "mappin.and.ellipse")
                .font(.title2)
                .foregroundStyle(MyAtlasTheme.moss)
            VStack(alignment: .leading, spacing: 3) {
                Text(place.name).font(.headline)
                Text(place.subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Text(place.visitedAt, format: .dateTime.month(.abbreviated).day())
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

private struct RegionDownloadSheet: View {
    @EnvironmentObject private var atlas: AtlasViewModel
    @Environment(\.dismiss) private var dismiss

    private let suggestions = [
        AtlasRegion(name: "Tokyo", countryCode: "JP", mapPackageSize: 320_000_000),
        AtlasRegion(name: "Paris", countryCode: "FR", mapPackageSize: 210_000_000),
        AtlasRegion(name: "New York City", countryCode: "US", mapPackageSize: 280_000_000)
    ]

    var body: some View {
        NavigationStack {
            List(suggestions) { region in
                HStack {
                    VStack(alignment: .leading) {
                        Text(region.name).font(.headline)
                        Text(region.mapPackageSize.formatted(.byteCount(style: .file)))
                            .font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button("Download") {
                        atlas.download(region: region)
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(MyAtlasTheme.ink)
                }
            }
            .navigationTitle("Offline maps")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Close") { dismiss() } }
            }
        }
    }
}

private struct AddPlaceSheet: View {
    @EnvironmentObject private var atlas: AtlasViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var subtitle = ""
    @State private var note = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Place") {
                    TextField("Name", text: $name)
                    TextField("City or region", text: $subtitle)
                }
                Section("Memory") {
                    TextField("What do you want to remember?", text: $note, axis: .vertical)
                        .lineLimit(3...6)
                }
                Section {
                    Button("Save place") {
                        atlas.add(place: Place(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Pinned place" : name,
                            subtitle: subtitle.isEmpty ? "Saved offline" : subtitle,
                            latitude: 0,
                            longitude: 0,
                            visitedAt: .now,
                            note: note.isEmpty ? nil : note
                        ))
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .navigationTitle("Save a place")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("Cancel") { dismiss() } }
            }
        }
    }
}

private extension DownloadState {
    var label: String {
        switch self {
        case .available: "Ready to download"
        case .downloading(let progress): "Downloading \(Int(progress * 100))%"
        case .downloaded: "Available offline"
        case .failed(let message): message
        }
    }
}
