# myatlas

myatlas is a private, offline-first personal atlas for remembering the places that matter. Download map regions before a trip, save places as you explore, and attach notes, photos, and voice messages without creating an account or sending your memories to a server.

## MVP

- SwiftUI app targeting iOS 17+
- Offline map regions through MapLibre Native
- On-device atlas data and media
- Saved places with text notes, photos, and voice notes
- Chronological travel history
- Foreground-only, opt-in route recording

The current vertical slice includes a shared local atlas session, seeded preview content,
download progress for candidate regions, saving a place with a memory or photo, and a
history timeline. Photos are written to the app's Application Support directory. The map
surface is intentionally a provider boundary until a licensed offline tile/style
distribution is selected.

Accounts, social sharing, cloud sync, background tracking, and friend discovery are intentionally outside the first release.

## Repository layout

```text
myatlas/                       SwiftUI application and feature views
Sources/MyAtlasCore/           Testable domain models and local store
Sources/MyAtlasCoreTests/      Swift Package domain tests
myatlasTests/                  Xcode application unit tests
myatlasUITests/                Xcode UI smoke tests
project.yml                    XcodeGen project specification
Package.swift                  Swift Package manifest for core logic
```

## Getting started on macOS

Requirements:

- Xcode 15 or newer
- iOS 17 SDK
- XcodeGen (`brew install xcodegen`)

Generate the Xcode project, then open it:

```sh
xcodegen generate
open myatlas.xcodeproj
```

Select the `myatlas` scheme and run it on an iOS 17 simulator or device. Run the tests with `Cmd-U` or:

```sh
xcodebuild test -project myatlas.xcodeproj -scheme myatlas -destination 'platform=iOS Simulator,name=iPhone 15'
```

The Linux development container cannot run Xcode or validate iOS builds. The editor diagnostics and repository checks can still be run here, but the first native build must happen on macOS.

## Map data and attribution

MapLibre is the rendering layer, not a tile-data provider. Before shipping region downloads, configure a tile/style source that explicitly permits offline or bulk downloads. Do not use a public OpenStreetMap tile endpoint as an unrestricted download service.

The production app must display the attribution required by the selected tile/style provider and by OpenStreetMap contributors where applicable. Keep the source configuration and any credentials out of the repository; use a local Xcode configuration or build setting for environment-specific endpoints.

## Privacy and storage

The MVP is local-only. Photos and audio should live in the app's Application Support directory, with lightweight metadata in the app database. Downloaded map packages and user media must never be committed to Git.

Permissions are requested only when a user starts the related action:

- Location for saving or recording places
- Camera for taking a photo
- Photo Library for choosing an existing photo
- Microphone for recording a voice note