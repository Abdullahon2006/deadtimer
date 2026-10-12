import Foundation

enum OfflineMapState: Equatable {
    case unavailable
    case ready
    case downloading(progress: Double)
    case failed(String)
}

protocol MapProvider {
    var state: OfflineMapState { get }
    func downloadRegion(identifier: String) async throws
    func removeRegion(identifier: String) async throws
}

struct MapProviderConfiguration {
    let styleURL: URL
    let attributionText: String
}