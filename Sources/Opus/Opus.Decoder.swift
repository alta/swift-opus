import AVFoundation
import Copus

public extension Opus {
	class Decoder {
		let format: AVAudioFormat
		let decoder: OpaquePointer

		// TODO: throw an error if format is unsupported
		public init(format: AVAudioFormat, application _: Application = .audio) throws {
			if !Opus.isValidFormat(format) {
				throw Opus.Error.badArg
			}

			self.format = format

			// Initialize Opus decoder
			var error: Opus.Error = .ok
			decoder = opus_decoder_create(Int32(format.sampleRate), Int32(format.channelCount), &error.rawValue)
			if error != .ok {
				throw error
			}
		}

		deinit {
			opus_decoder_destroy(decoder)
		}

		public func reset() throws {
			let error = Opus.Error(opus_decoder_init(decoder, Int32(format.sampleRate), Int32(format.channelCount)))
			if error != .ok {
				throw error
			}
		}

		// TODO: decode methods
	}
}
