import AVFoundation
import XCTest

@testable import Opus

final class AVAudioFormatTests: XCTestCase {
	static let commonFormatInt16Mono = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatInt16Stereo = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatInt16Stereo8 = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!
	static let commonFormatInt16Stereo12 = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!
	static let commonFormatInt16Stereo16 = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!
	static let commonFormatInt16Stereo24 = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!
	static let commonFormatInt16Stereo44 = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44000, channels: 2, interleaved: true)!
	static let commonFormatInt16StereoNonInterleaved = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: false)!
	static let commonFormatInt32Mono = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatInt32Stereo = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatFloat32Mono = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatFloat32Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let commonFormatFloat64Mono = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 1, interleaved: true)!
	static let commonFormatFloat64Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 2, interleaved: true)!

	static let formatInt16Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt16Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt16StereoNonInterleaved = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: true])!
	static let formatInt32Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatInt32Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!
	static let formatFloat32Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!
	static let formatFloat32Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!

	static let formatOpusMono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1])!
	static let formatOpusStereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2])!

	static let validFormats = [
		commonFormatInt16Mono,
		commonFormatInt16Stereo,
		commonFormatInt16Stereo8,
		commonFormatInt16Stereo12,
		commonFormatInt16Stereo16,
		commonFormatInt16Stereo24,
		commonFormatFloat32Mono,
		commonFormatFloat32Stereo,
		formatInt16Mono,
		formatInt16Stereo,
		formatFloat32Mono,
		formatFloat32Stereo,
	]

	static let invalidFormats = [
		commonFormatInt16StereoNonInterleaved,
		commonFormatInt16Stereo44,
		commonFormatInt32Mono,
		commonFormatInt32Stereo,
		commonFormatFloat64Mono,
		commonFormatFloat64Stereo,
		formatInt16StereoNonInterleaved,
		formatInt32Mono,
		formatInt32Stereo,
		formatOpusMono,
		formatOpusStereo,
	]

	func testIsValidFormat() throws {
		Self.validFormats.forEach {
			XCTAssert($0.isValidOpusFormat, $0.description)
		}

		Self.invalidFormats.forEach {
			XCTAssertFalse($0.isValidOpusFormat, $0.description)
		}
	}
}
