import AVFoundation

public extension AVAudioFrameCount {
	// Opus can encode packets as small as 2.5ms at 8khz (20 samples)
	static let opusMin: Self = 20

	// Opus can encode packets as large as to 120ms at 48khz (5760 samples)
	static let opusMax: Self = 5760
}
