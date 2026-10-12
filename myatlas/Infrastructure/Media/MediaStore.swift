import Foundation

actor MediaStore {
    enum MediaStoreError: Error {
        case invalidFilename
    }

    private let directory: URL

    init(fileManager: FileManager = .default) throws {
        let applicationSupport = try fileManager.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        directory = applicationSupport.appendingPathComponent("Media", isDirectory: true)
        try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    func save(_ data: Data, filename: String) throws -> URL {
        guard filename.isEmpty == false, filename.contains("/") == false else {
            throw MediaStoreError.invalidFilename
        }
        let url = directory.appendingPathComponent(filename)
        try data.write(to: url, options: .atomic)
        return url
    }

    func data(for attachment: PlaceAttachment) throws -> Data {
        try Data(contentsOf: directory.appendingPathComponent(attachment.filename))
    }

    func remove(_ attachment: PlaceAttachment) throws {
        try FileManager.default.removeItem(at: directory.appendingPathComponent(attachment.filename))
    }
}
