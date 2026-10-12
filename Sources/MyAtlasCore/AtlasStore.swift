import Foundation

public actor AtlasStore {
    private var regions: [AtlasRegion]
    private var places: [Place]
    private var entries: [JournalEntry]

    public init(
        regions: [AtlasRegion] = [],
        places: [Place] = [],
        entries: [JournalEntry] = []
    ) {
        self.regions = regions
        self.places = places
        self.entries = entries
    }

    public func allRegions() -> [AtlasRegion] {
        regions
    }

    public func allPlaces() -> [Place] {
        places.sorted { $0.visitedAt > $1.visitedAt }
    }

    public func add(place: Place) {
        places.append(place)
    }

    public func add(entry: JournalEntry) {
        entries.append(entry)
    }

    public func entries(for placeID: UUID) -> [JournalEntry] {
        entries.filter { $0.placeID == placeID }.sorted { $0.createdAt > $1.createdAt }
    }
}