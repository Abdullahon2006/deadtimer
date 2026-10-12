import Foundation
import SwiftUI

@MainActor
final class AtlasViewModel: ObservableObject {
    @Published private(set) var regions: [AtlasRegion]
    @Published private(set) var places: [Place]
    @Published private(set) var entries: [JournalEntry]

    private let store: AtlasStore
    private var downloadTasks: [UUID: Task<Void, Never>] = [:]

    init(store: AtlasStore? = nil) {
        let seedRegions = [
            AtlasRegion(
                name: "Lisbon & Sintra",
                countryCode: "PT",
                mapPackageSize: 182_000_000,
                downloadState: .downloaded
            )
        ]
        let seedPlaces = [
            Place(
                name: "Miradouro da Senhora do Monte",
                subtitle: "Lisbon, Portugal",
                latitude: 38.7192,
                longitude: -9.1326,
                visitedAt: Date(timeIntervalSinceNow: -86_400 * 2),
                note: "The city opened up below us just before sunset.",
                attachmentCount: 2
            )
        ]
        self.store = store ?? AtlasStore(regions: seedRegions, places: seedPlaces)
        self.regions = seedRegions
        self.places = seedPlaces
        self.entries = []
    }

    var downloadedRegions: [AtlasRegion] {
        regions.filter {
            if case .downloaded = $0.downloadState { return true }
            return false
        }
    }

    var recentPlaces: [Place] {
        places.sorted { $0.visitedAt > $1.visitedAt }
    }

    func download(region: AtlasRegion) {
        guard downloadTasks[region.id] == nil else { return }
        update(region: region, state: .downloading(progress: 0))

        downloadTasks[region.id] = Task { [weak self] in
            for step in 1...10 {
                try? await Task.sleep(for: .milliseconds(120))
                guard !Task.isCancelled, let self else { return }
                self.setDownloadProgress(Double(step) / 10, for: region.id)
            }
            guard !Task.isCancelled, let self else { return }
            self.finishDownload(for: region.id)
        }
    }

    func cancelDownload(for region: AtlasRegion) {
        downloadTasks[region.id]?.cancel()
        downloadTasks[region.id] = nil
        update(region: region, state: .available)
    }

    func add(place: Place) {
        places.insert(place, at: 0)
        Task {
            await store.add(place: place)
        }
    }

    func add(entry: JournalEntry) {
        entries.insert(entry, at: 0)
        Task {
            await store.add(entry: entry)
        }
    }

    private func update(region: AtlasRegion, state: DownloadState) {
        var updated = region
        updated.downloadState = state
        regions.removeAll { $0.id == region.id }
        regions.append(updated)
        regions.sort { $0.name < $1.name }
        Task {
            await store.update(region: updated)
        }
    }

    private func setDownloadProgress(_ progress: Double, for id: UUID) {
        guard let region = regions.first(where: { $0.id == id }) else { return }
        update(region: region, state: .downloading(progress: progress))
    }

    private func finishDownload(for id: UUID) {
        guard let region = regions.first(where: { $0.id == id }) else { return }
        update(region: region, state: .downloaded)
        downloadTasks[id] = nil
    }
}
