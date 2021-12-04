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


    func test_CorruptedOpusData_ThrowsInvalidPacketError() throws {
        guard let opusFormat = AVAudioFormat(opusPCMFormat: .int16, sampleRate: .opus16khz, channels: 1) else {
            XCTFail("Unable to generate desired opusFormat")
            return
        }

        let opusDecoder = try Opus.Decoder(format: opusFormat)
        let corruptedOpusData = Data([191, 232, 174, 215, 224, 130, 236, 126, 177, 204, 165, 85, 230, 201, 43, 16, 207, 120, 223, 247, 59, 117, 41, 235, 55, 96, 78, 68, 7, 207, 184, 255, 254, 0, 0, 0, 0, 0, 0, 0])

        XCTAssertThrowsError(try opusDecoder.decode(corruptedOpusData)) { error in
            guard let opusError = error as? Opus.Error else {
                XCTFail("Unable to cast error to Opus.Error")
                return
            }

            XCTAssertEqual(opusError , Opus.Error.invalidPacket)
        }
    }
}
