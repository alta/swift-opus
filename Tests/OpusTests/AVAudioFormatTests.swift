import AVFoundation
import XCTest

@testable import Opus

final class AVAudioFormatTests: XCTestCase {
	static let nilFormats = [
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: 44100, channels: 1),
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: 44100, channels: 2),
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: 44100, channels: 1),
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: 44100, channels: 2),
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus48khz, channels: 0),
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus48khz, channels: 3),
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus48khz, channels: 4),
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus48khz, channels: 5),
	]

	func testInitializer() throws {
		Self.nilFormats.forEach {
			XCTAssertNil($0)
		}
	}

	static let validFormats = [
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 8000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 1, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: true)!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: true, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus12khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus12khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus16khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus16khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus24khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus24khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus48khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus48khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus12khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus12khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus16khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus16khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus24khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus24khz, channels: 2)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus48khz, channels: 1)!,
		AVAudioFormat(opusPCMFormat: .float32, sampleRate: .opus48khz, channels: 2)!,
	]

	static let invalidFormats = [
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: false)!,
		AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 44100, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 1, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 2, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 1, interleaved: true)!,
		AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 2, interleaved: true)!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 16, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: true])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatLinearPCM, AVLinearPCMIsFloatKey: false, AVLinearPCMBitDepthKey: 32, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2, AVLinearPCMIsNonInterleaved: false])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 1])!,
		AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000, AVNumberOfChannelsKey: 2])!,
	]

	func testIsValidFormat() throws {
		Self.validFormats.forEach {
			XCTAssert($0.isValidOpusPCMFormat, $0.description)
		}

		Self.invalidFormats.forEach {
			XCTAssertFalse($0.isValidOpusPCMFormat, $0.description)
		}
	}
}
