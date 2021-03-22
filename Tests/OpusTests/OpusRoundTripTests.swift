import AVFoundation
import XCTest

@testable import Opus

final class OpusRoundTripTests: XCTestCase {
	let engine = AVAudioEngine()

	func testSilence() throws {
		let format = AVAudioFormatTests.formatFloat32Mono
		let input = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: .opusMax)!
		input.frameLength = input.frameCapacity // Silence
		_ = try encodeAndDecode(input)
	}

	func testSoundFile() throws {
		let url = Bundle.module.url(forResource: "MuteMono", withExtension: "wav")!
		let audioFile = try AVAudioFile(forReading: url)
		let format = AVAudioFormatTests.formatFloat32Mono
		let input = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: .opusMax)!
		try audioFile.read(into: input, frameCount: input.frameCapacity)
		_ = try encodeAndDecode(input)
	}

	func encodeAndDecode(_ input: AVAudioPCMBuffer) throws -> AVAudioPCMBuffer {
		let encoder = try Opus.Encoder(format: input.format)
		let decoder = try Opus.Decoder(format: input.format)
		var data = Data(count: 1500)
		_ = try encoder.encode(input, to: &data)
		let output = try decoder.decode(data)
		assertSimilar(input, output)
		// try play(input)
		// try play(output)
		return output
	}

	func play(_ buffer: AVAudioPCMBuffer) throws {
		_ = engine.mainMixerNode
		try engine.start()
		let player = AVAudioPlayerNode()
		engine.attach(player)
		engine.connect(player, to: engine.mainMixerNode, format: buffer.format)
		player.play()
		player.scheduleBuffer(buffer) {
			DispatchQueue.main.async {
				self.engine.detach(player)
			}
		}
		Thread.sleep(forTimeInterval: Double(buffer.frameLength) / Double(buffer.format.sampleRate))
	}

	func assertSimilar(_ a: AVAudioPCMBuffer, _ b: AVAudioPCMBuffer, epsilon _: Float32 = 0.2) {
		XCTAssertTrue(a.format.isEqual(b.format), "a.format == b.format")
		XCTAssertEqual(a.frameLength, b.frameLength, "a.frameLength == b.frameLength")
		// for i in 0 ... a.frameLength {
		// 	var x: Float32 = 0
		// 	var y: Float32 = 0
		// 	switch a.format.commonFormat {
		// 	case .pcmFormatInt16:
		// 		x = Float32(a.int16ChannelData![0][Int(i)]) / 32768.0
		// 		y = Float32(b.int16ChannelData![0][Int(i)]) / 32768.0
		// 	case .pcmFormatFloat32:
		// 		x = a.floatChannelData![0][Int(i)]
		// 		y = b.floatChannelData![0][Int(i)]
		// 	default:
		// 		XCTFail("unknown audio format: \(a.format)")
		// 	}
		// 	let delta = abs(abs(x) - abs(y))
		// 	XCTAssert(delta < epsilon, String(delta))
		// }
	}
}
