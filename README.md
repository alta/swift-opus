# Swift Opus

Type-safe [Swift](https://swift.org/) bindings for the [Opus audio codec](https://opus-codec.org/) on Apple platforms (iOS, tvOS, macOS, watchOS).

This package enables low-level Opus packet encoding and decoding to an `AVAudioPCMBuffer` suitable for playback via an `AVAudioEngine` and `AVAudioPlayerNode`. This was built for a now-defunct audio app for iOS and macOS, and runs reliably with multiple 48 kHz Opus audio channels over a typical 4G connection on modern iPhone devices.

## Installation

### Swift Package Manager

Use [Swift Package Manager](https://swift.org/package-manager/) to add this package to your Xcode project or `Package.swift` manifest.

```swift
dependencies: [
    .package(url: "https://github.com/alta/swift-opus.git", from: "1.0.0")
]
```

### CocoaPods

Add the pod to your `Podfile`:

```ruby
platform :ios, "12.0"

target "YourApp" do
  pod "Opus", :git => "https://github.com/alta/swift-opus.git", :tag => "1.0.0"
end
```

### Note

This project does not vendor a precompiled binary. It builds the upstream Opus C sources from the [Sources/Copus](Sources/Copus) git submodule and layers the Swift API in [Sources/Opus](Sources/Opus) on top. See [Package.swift](Package.swift) and [Opus.podspec](Opus.podspec) for the package definitions.

## Usage

Opus only supports the sample rates defined by the codec: `8000`, `12000`, `16000`, `24000`, and `48000` Hz. The Swift helpers in this package also constrain channel counts to `1` or `2`.

```swift
import AVFoundation
import Opus

let format = AVAudioFormat(
    opusPCMFormat: .float32,
    sampleRate: .opus48khz,
    channels: 1
)!

let encoder = try Opus.Encoder(format: format, application: .audio)
let decoder = try Opus.Decoder(format: format)

var packet = Data(count: 1500)
let encodedBytes = try encoder.encode(inputBuffer, to: &packet)
assert(encodedBytes == packet.count)

let decodedBuffer = try decoder.decode(packet)
```

The package exposes `Opus.Encoder` and `Opus.Decoder` directly over `AVAudioPCMBuffer`, which keeps the call site small and works well with `AVAudioEngine` pipelines.

## Validation

The repository currently validates both package managers with:

```bash
swift test
pod lib lint --allow-warnings --platforms=ios,macos
```

## License

See [LICENSE](LICENSE) for more information.
