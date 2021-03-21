import AVFoundation
import XCTest

@testable import Opus

final class OpusRoundTripTests: XCTestCase {
	func testSilence() throws {
		let format = OpusTests.formatFloat32Mono
		let encoder = try Opus.Encoder(format: format)
		let decoder = try Opus.Decoder(format: format)

		let input = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 5760)!
		input.frameLength = input.frameCapacity

		var data = Data(count: 1500)

		let encodedSize = try encoder.encode(input, to: &data)
		XCTAssertEqual(encodedSize, 14)
	}
}
