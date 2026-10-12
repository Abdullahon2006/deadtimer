import Foundation

public actor AtlasStore {
    public static var defaultPersistenceURL: URL? {
        try? FileManager.default.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        ).appendingPathComponent("atlas.json")
    }

    public nonisolated let initialRegions: [AtlasRegion]
    public nonisolated let initialPlaces: [Place]
    public nonisolated let initialEntries: [JournalEntry]
    public nonisolated let initialAttachments: [PlaceAttachment]

    private var regions: [AtlasRegion]
    private var places: [Place]
    private var entries: [JournalEntry]
    private var attachments: [PlaceAttachment]
    private let persistenceURL: URL?

    public init(
        regions: [AtlasRegion] = [],
        places: [Place] = [],
        entries: [JournalEntry] = [],
        attachments: [PlaceAttachment] = [],
        persistenceURL: URL? = nil
    ) {
        self.persistenceURL = persistenceURL
        if let persistenceURL,
           let data = try? Data(contentsOf: persistenceURL),
           let snapshot = try? JSONDecoder().decode(Snapshot.self, from: data) {
            self.regions = snapshot.regions
            self.places = snapshot.places
            self.entries = snapshot.entries
            self.attachments = snapshot.attachments
        } else {
            self.regions = regions
            self.places = places
            self.entries = entries
            self.attachments = attachments
        }
        self.initialRegions = self.regions
        self.initialPlaces = self.places
        self.initialEntries = self.entries
        self.initialAttachments = self.attachments
    }

    public func allRegions() -> [AtlasRegion] {
        regions
    }

    public func allPlaces() -> [Place] {
        places.sorted { $0.visitedAt > $1.visitedAt }
    }

    public func add(place: Place) {
        places.append(place)
        persist()
    }

    public func update(place: Place) {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else {
            return
        }
        places[index] = place
        persist()
    }

    public func add(entry: JournalEntry) {
        entries.append(entry)
        persist()
    }

    public func add(attachment: PlaceAttachment) {
        attachments.append(attachment)
        persist()
    }

    public func attachments(for placeID: UUID) -> [PlaceAttachment] {
        attachments.filter { $0.placeID == placeID }.sorted { $0.createdAt > $1.createdAt }
    }

    public func add(region: AtlasRegion) {
        regions.append(region)
        persist()
    }

    public func update(region: AtlasRegion) {
        if let index = regions.firstIndex(where: { $0.id == region.id }) {
            regions[index] = region
        } else {
            regions.append(region)
        }
        persist()
    }

    public func remove(regionID: UUID) {
        regions.removeAll { $0.id == regionID }
        persist()
    }

    public func entries(for placeID: UUID) -> [JournalEntry] {
        entries.filter { $0.placeID == placeID }.sorted { $0.createdAt > $1.createdAt }
    }

    private func persist() {
        guard let persistenceURL else { return }
        let snapshot = Snapshot(
            regions: regions,
            places: places,
            entries: entries,
            attachments: attachments
        )
        guard let data = try? JSONEncoder().encode(snapshot) else { return }
        try? FileManager.default.createDirectory(
            at: persistenceURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
        try? data.write(to: persistenceURL, options: .atomic)
    }

    private struct Snapshot: Codable {
        let regions: [AtlasRegion]
        let places: [Place]
        let entries: [JournalEntry]
        let attachments: [PlaceAttachment]

        init(
            regions: [AtlasRegion],
            places: [Place],
            entries: [JournalEntry],
            attachments: [PlaceAttachment]
        ) {
            self.regions = regions
            self.places = places
            self.entries = entries
            self.attachments = attachments
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            regions = try container.decode([AtlasRegion].self, forKey: .regions)
            places = try container.decode([Place].self, forKey: .places)
            entries = try container.decode([JournalEntry].self, forKey: .entries)
            attachments = try container.decodeIfPresent([PlaceAttachment].self, forKey: .attachments) ?? []
        }
    }
}