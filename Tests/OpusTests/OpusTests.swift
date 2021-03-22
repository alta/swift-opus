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
}
