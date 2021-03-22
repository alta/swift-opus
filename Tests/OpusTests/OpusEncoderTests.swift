import AVFoundation
import XCTest

@testable import Opus

final class OpusEncoderTests: XCTestCase {
	func testInit() throws {
		try AVAudioFormatTests.validFormats.forEach {
			_ = try Opus.Encoder(format: $0)
		}

		try AVAudioFormatTests.invalidFormats.forEach {
			XCTAssertThrowsError(try Opus.Encoder(format: $0)) { error in
				XCTAssertEqual(error as! Opus.Error, Opus.Error.badArg)
			}
		}
	}
}
