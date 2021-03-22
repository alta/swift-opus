import AVFoundation
import Opus
import XCTest

final class OpusErrorTests: XCTestCase {
	func testErrorValues() {
		XCTAssertEqual(Opus.Error.ok.rawValue, OPUS_OK)
		XCTAssertEqual(Opus.Error.badArgument.rawValue, OPUS_BAD_ARG)
		XCTAssertEqual(Opus.Error.bufferTooSmall.rawValue, OPUS_BUFFER_TOO_SMALL)
		XCTAssertEqual(Opus.Error.internalError.rawValue, OPUS_INTERNAL_ERROR)
		XCTAssertEqual(Opus.Error.invalidPacket.rawValue, OPUS_INVALID_PACKET)
		XCTAssertEqual(Opus.Error.unimplemented.rawValue, OPUS_UNIMPLEMENTED)
		XCTAssertEqual(Opus.Error.invalidState.rawValue, OPUS_INVALID_STATE)
		XCTAssertEqual(Opus.Error.allocationFailure.rawValue, OPUS_ALLOC_FAIL)
	}
}
