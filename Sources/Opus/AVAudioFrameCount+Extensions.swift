import AVFoundation

extension AVAudioFrameCount {
	// Opus can encode packets as small as 2.5ms at 8khz (20 samples)
	public static let opusMin: Self = 20

	// Opus can encode packets as large as to 120ms at 48khz (5760 samples)
	public static let opusMax: Self = 5760
}
