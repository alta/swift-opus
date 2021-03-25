# Swift Opus

Type-safe [Swift](https://swift.org/) bindings for the [Opus audio codec](https://opus-codec.org/) on Apple platforms (iOS, tvOS, macOS, watchOS).

This package enables low-level Opus packet encoding and decoding to an `AVAudioPCMBuffer` suitable for playback via an `AVAudioEngine` and `AVAudioPlayerNode`. This was built for a now-defunct audio app for iOS and macOS, and runs reliably with multiple 48khz Opus audio channels over a typical 4G connection on modern iPhone devices.
## Installation

Use [Swift Package Manager](https://swift.org/package-manager/) to add this to your Xcode project or Swift package.

### Note

This package neither vendors the original Opus source code or embeds precompiled libraries or binary frameworks. It embeds the current Opus C source as a [git submodule](Sources/Copus), which Swift Package Manager will automatically download as part of the build process. See [Package.swift](Package.swift) for details.

## Usage

TODO

## License

See [LICENSE](LICENSE) for more information.
