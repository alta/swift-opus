import AVFoundation
import XCTest

@testable import Opus

final class OpusTests: XCTestCase {
	func testMemorySizes() {
		// These are implementation independent, and may change:
		XCTAssertEqual(opus_decoder_get_size(1), 18228)
		XCTAssertEqual(opus_decoder_get_size(2), 26996)
	}

	func testErrorValues() {
		XCTAssertEqual(Opus.Error.ok.rawValue, OPUS_OK)
		XCTAssertEqual(Opus.Error.badArg.rawValue, OPUS_BAD_ARG)
		XCTAssertEqual(Opus.Error.bufferTooSmall.rawValue, OPUS_BUFFER_TOO_SMALL)
		XCTAssertEqual(Opus.Error.internalError.rawValue, OPUS_INTERNAL_ERROR)
		XCTAssertEqual(Opus.Error.invalidPacket.rawValue, OPUS_INVALID_PACKET)
		XCTAssertEqual(Opus.Error.unimplemented.rawValue, OPUS_UNIMPLEMENTED)
		XCTAssertEqual(Opus.Error.invalidState.rawValue, OPUS_INVALID_STATE)
		XCTAssertEqual(Opus.Error.allocFail.rawValue, OPUS_ALLOC_FAIL)
	}

	func testApplicationValues() {
		XCTAssertEqual(Opus.Application.audio.rawValue, OPUS_APPLICATION_AUDIO)
		XCTAssertEqual(Opus.Application.voip.rawValue, OPUS_APPLICATION_VOIP)
		XCTAssertEqual(Opus.Application.restrictedLowDelay.rawValue, OPUS_APPLICATION_RESTRICTED_LOWDELAY)
	}

	static let formatInt16Mono = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 1, interleaved: true)!
	static let formatInt16Stereo = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: true)!
	static let formatInt16StereoNonInterleaved = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 48000, channels: 2, interleaved: false)!
	static let formatInt32Mono = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let formatInt32Stereo = AVAudioFormat(commonFormat: .pcmFormatInt32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let formatFloat32Mono = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 1, interleaved: true)!
	static let formatFloat32Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 2, interleaved: true)!
	static let formatFloat64Mono = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 1, interleaved: true)!
	static let formatFloat64Stereo = AVAudioFormat(commonFormat: .pcmFormatFloat64, sampleRate: 48000, channels: 2, interleaved: true)!
	static let formatOpus48Mono = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000.0, AVNumberOfChannelsKey: 1])!
	static let formatOpus48Stereo = AVAudioFormat(settings: [AVFormatIDKey: kAudioFormatOpus, AVSampleRateKey: 48000.0, AVNumberOfChannelsKey: 2])!

	static let validFormats = [
		formatInt16Mono,
		formatInt16Stereo,
		formatFloat32Mono,
		formatFloat32Stereo,
	]

	static let invalidFormats = [
		formatInt16StereoNonInterleaved,
		formatInt32Mono,
		formatInt32Stereo,
		formatFloat64Mono,
		formatFloat64Stereo,
		formatOpus48Mono,
		formatOpus48Stereo,
	]

	func testIsValidFormat() throws {
		Self.validFormats.forEach {
			XCTAssert(Opus.isValidFormat($0))
		}

		Self.invalidFormats.forEach {
			XCTAssertFalse(Opus.isValidFormat($0))
		}
	}

	//    func testRecorder() throws {
	//        let recorder = try Opus.Recorder()
	//        try recorder.start()
	//        recorder.stop()
	//    }
}
