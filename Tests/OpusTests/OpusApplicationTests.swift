import AVFoundation
import Opus
import XCTest

final class OpusApplicationTests: XCTestCase {
	func testInitializer() {
		_ = Opus.Application(Int(0))
		_ = Opus.Application(UInt8(0))
		_ = Opus.Application(UInt16(0))
		_ = Opus.Application(UInt32(0))
		_ = Opus.Application(UInt64(0))
		_ = Opus.Application(Int8(0))
		_ = Opus.Application(Int16(0))
		_ = Opus.Application(Int32(0))
		_ = Opus.Application(Int64(0))
	}

	func testValues() {
		XCTAssertEqual(Opus.Application.audio.rawValue, OPUS_APPLICATION_AUDIO)
		XCTAssertEqual(Opus.Application.voip.rawValue, OPUS_APPLICATION_VOIP)
		XCTAssertEqual(Opus.Application.restrictedLowDelay.rawValue, OPUS_APPLICATION_RESTRICTED_LOWDELAY)
	}
}
