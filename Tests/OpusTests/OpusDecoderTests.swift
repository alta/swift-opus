import AVFoundation
import XCTest

@testable import Opus

final class OpusDecoderTests: XCTestCase {
	func testInit() throws {
		try AVAudioFormatTests.validFormats.forEach {
			_ = try Opus.Decoder(format: $0)
		}

		try AVAudioFormatTests.invalidFormats.forEach {
			XCTAssertThrowsError(try Opus.Decoder(format: $0)) { error in
				XCTAssertEqual(error as! Opus.Error, Opus.Error.badArgument)
			}
		}
	}
}
