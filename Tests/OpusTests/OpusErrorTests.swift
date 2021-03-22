import AVFoundation
import Opus
import XCTest

final class OpusErrorTests: XCTestCase {
	func testInitializer() {
		_ = Opus.Error(Int(0))
		_ = Opus.Error(UInt8(0))
		_ = Opus.Error(UInt16(0))
		_ = Opus.Error(UInt32(0))
		_ = Opus.Error(UInt64(0))
		_ = Opus.Error(Int8(0))
		_ = Opus.Error(Int16(0))
		_ = Opus.Error(Int32(0))
		_ = Opus.Error(Int64(0))
	}

	func testValues() {
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
