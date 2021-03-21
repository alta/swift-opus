import AVFoundation
import Copus

public extension Opus {
	class Encoder {
		public static let defaultFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 48000, channels: 1, interleaved: true)!

		let format: AVAudioFormat
		let application: Application
		let encoder: OpaquePointer

		// TODO: throw an error if format is unsupported
		public init(format: AVAudioFormat, application: Application = .audio) throws {
			if !Opus.isValidFormat(format) {
				throw Opus.Error.badArg
			}

			self.format = format
			self.application = application

			// Initialize Opus encoder
			var error: Opus.Error = .ok
			encoder = opus_encoder_create(Int32(format.sampleRate), Int32(format.channelCount), application.rawValue, &error.rawValue)
			if error != .ok {
				throw error
			}
		}

		deinit {
			opus_encoder_destroy(encoder)
		}

		public func reset() throws {
			let error = Opus.Error(opus_encoder_init(encoder, Int32(format.sampleRate), Int32(format.channelCount), application.rawValue))
			if error != .ok {
				throw error
			}
		}

		public func encode(_ input: AVAudioPCMBuffer, to output: inout [UInt8]) throws -> Int {
			if input.format != format {
				throw Opus.Error.badArg
			}
			return try output.withUnsafeMutableBufferPointer {
				try encode(input, to: $0)
			}
		}

		public func encode(_ input: AVAudioPCMBuffer, to output: UnsafeMutableRawBufferPointer) throws -> Int {
			if input.format != format {
				throw Opus.Error.badArg
			}
			let umbp = UnsafeMutableBufferPointer(start: output.baseAddress!.bindMemory(to: UInt8.self, capacity: output.count), count: output.count)
			return try encode(input, to: umbp)
		}

		public func encode(_ input: AVAudioPCMBuffer, to output: UnsafeMutableBufferPointer<UInt8>) throws -> Int {
			if input.format != format {
				throw Opus.Error.badArg
			}
			switch format.commonFormat {
			case .pcmFormatInt16:
				let input = UnsafeBufferPointer(start: input.int16ChannelData![0], count: Int(input.frameLength * format.channelCount))
				return try encode(input, to: output)
			case .pcmFormatFloat32:
				let input = UnsafeBufferPointer(start: input.floatChannelData![0], count: Int(input.frameLength * format.channelCount))
				return try encode(input, to: output)
			default:
				throw Opus.Error.badArg
			}
		}

		public func encode(_ input: UnsafeBufferPointer<Int16>, to output: UnsafeMutableBufferPointer<UInt8>) throws -> Int {
			let count = opus_encode(
				encoder,
				input.baseAddress!,
				Int32(input.count) / Int32(format.channelCount),
				output.baseAddress!,
				Int32(output.count)
			)
			if count <= 0 {
				throw Opus.Error(count)
			}
			return Int(count)
		}

		public func encode(_ input: UnsafeBufferPointer<Float32>, to output: UnsafeMutableBufferPointer<UInt8>) throws -> Int {
			let count = opus_encode_float(
				encoder,
				input.baseAddress!,
				Int32(input.count) / Int32(format.channelCount),
				output.baseAddress!,
				Int32(output.count)
			)
			if count <= 0 {
				throw Opus.Error(count)
			}
			return Int(count)
		}
	}
}
