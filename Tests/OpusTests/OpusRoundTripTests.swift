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

		let output = try decoder.decode(data)

		assertSimilar(input, output)
	}

	func assertSimilar(_ a: AVAudioPCMBuffer, _ b: AVAudioPCMBuffer, epsilon: Float32 = 0.00001) {
		XCTAssertTrue(a.format.isEqual(b.format), "a.format == b.format")
		XCTAssertEqual(a.frameLength, b.frameLength, "a.frameLength == b.frameLength")
		for i in 0 ... a.frameLength {
			let x = a.floatChannelData![0][Int(i)]
			let y = b.floatChannelData![0][Int(i)]
			XCTAssert(abs(x - y) < epsilon)
		}
	}
}
