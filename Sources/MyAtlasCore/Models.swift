import Foundation

public struct AtlasRegion: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var countryCode: String
    public var mapPackageSize: Int64
    public var downloadState: DownloadState

    public init(
        id: UUID = UUID(),
        name: String,
        countryCode: String,
        mapPackageSize: Int64,
        downloadState: DownloadState = .available
    ) {
        self.id = id
        self.name = name
        self.countryCode = countryCode
        self.mapPackageSize = mapPackageSize
        self.downloadState = downloadState
    }
}

public enum DownloadState: Codable, Equatable, Sendable {
    case available
    case downloading(progress: Double)
    case downloaded
    case failed(message: String)
}

public struct Place: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public var name: String
    public var subtitle: String
    public var latitude: Double
    public var longitude: Double
    public var visitedAt: Date
    public var note: String?
    public var attachmentCount: Int

    public init(
        id: UUID = UUID(),
        name: String,
        subtitle: String,
        latitude: Double,
        longitude: Double,
        visitedAt: Date,
        note: String? = nil,
        attachmentCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.latitude = latitude
        self.longitude = longitude
        self.visitedAt = visitedAt
        self.note = note
        self.attachmentCount = attachmentCount
    }
}

public struct JournalEntry: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let placeID: UUID
    public var body: String
    public var createdAt: Date

    public init(id: UUID = UUID(), placeID: UUID, body: String, createdAt: Date = .now) {
        self.id = id
        self.placeID = placeID
        self.body = body
        self.createdAt = createdAt
    }
}