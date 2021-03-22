import AVFoundation
import Opus
import XCTest

final class OpusApplicationTests: XCTestCase {
	func testApplicationValues() {
		XCTAssertEqual(Opus.Application.audio.rawValue, OPUS_APPLICATION_AUDIO)
		XCTAssertEqual(Opus.Application.voip.rawValue, OPUS_APPLICATION_VOIP)
		XCTAssertEqual(Opus.Application.restrictedLowDelay.rawValue, OPUS_APPLICATION_RESTRICTED_LOWDELAY)
	}
}
