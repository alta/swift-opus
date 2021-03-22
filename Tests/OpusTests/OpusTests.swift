import AVFoundation
import Opus
import XCTest

final class OpusTests: XCTestCase {
	// Validate that namespaces are empty enums, with no values.
	func testEnumCases() {
		XCTAssertEqual(Opus.allCases.count, 0)
	}

	func testMemorySizes() {
		// These are implementation independent, and may change:
		XCTAssertEqual(opus_decoder_get_size(1), 18228)
		XCTAssertEqual(opus_decoder_get_size(2), 26996)
	}
}
