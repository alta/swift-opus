import AVFoundation
import XCTest

@testable import Opus

final class OpusDecoderTests: XCTestCase {
	func testInit() throws {
		try OpusTests.validFormats.forEach {
			_ = try Opus.Decoder(format: $0)
		}

		try OpusTests.invalidFormats.forEach {
			XCTAssertThrowsError(try Opus.Decoder(format: $0)) { error in
				XCTAssertEqual(error as! Opus.Error, Opus.Error.badArg)
			}
		}
	}
}
