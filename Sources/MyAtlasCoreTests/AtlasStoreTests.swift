import XCTest
@testable import MyAtlasCore

final class AtlasStoreTests: XCTestCase {
    func testPlacesAreReturnedNewestFirst() async {
        let older = Place(
            name: "Lisbon",
            subtitle: "Portugal",
            latitude: 38.7223,
            longitude: -9.1393,
            visitedAt: Date(timeIntervalSince1970: 10)
        )
        let newer = Place(
            name: "Porto",
            subtitle: "Portugal",
            latitude: 41.1579,
            longitude: -8.6291,
            visitedAt: Date(timeIntervalSince1970: 20)
        )
        let store = AtlasStore(places: [older, newer])

        let places = await store.allPlaces()

        XCTAssertEqual(places.map(\.name), ["Porto", "Lisbon"])
    }

    func testRegionCanBeUpdatedAndRemoved() async {
        let region = AtlasRegion(name: "Kyoto", countryCode: "JP", mapPackageSize: 100)
        let store = AtlasStore(regions: [region])

        var downloaded = region
        downloaded.downloadState = .downloaded
        await store.update(region: downloaded)
        let updatedRegions = await store.allRegions()
        XCTAssertEqual(updatedRegions.first?.downloadState, .downloaded)

        await store.remove(regionID: region.id)
        let remainingRegions = await store.allRegions()
        XCTAssertTrue(remainingRegions.isEmpty)
    }
}