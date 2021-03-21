import AVFoundation
import XCTest

@testable import Opus

final class OpusEncoderTests: XCTestCase {
    func testInit() throws {
        try OpusTests.validFormats.forEach {
            _ = try Opus.Encoder(format: $0)
        }

        try OpusTests.invalidFormats.forEach {
            XCTAssertThrowsError(try Opus.Encoder(format: $0)) { error in
                XCTAssertEqual(error as! Opus.Error, Opus.Error.badArg)
            }
        }
    }
}
