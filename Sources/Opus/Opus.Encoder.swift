import AVFoundation
import Copus

public extension Opus {
	class Encoder {
		let format: AVAudioFormat
		let application: Application
		let encoder: OpaquePointer
		let customFrameSize: Int32?

		public init(format: AVAudioFormat, application: Application = .audio) throws {
			customFrameSize = nil
			if !format.isValidOpusPCMFormat {
				throw Opus.Error.badArgument
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

		public init(customOpus: OpaquePointer,
		            format: AVAudioFormat,
		            customFrameSize: UInt32,
		            application: Application = .audio) throws
		{
			self.customFrameSize = Int32(customFrameSize)
			if !format.isValidOpusPCMFormat {
				throw Opus.Error.badArgument
			}
			self.format = format
			self.application = application

			// Initialize Opus encoder
			var error: Opus.Error = .ok
			encoder = opus_custom_encoder_create(
				customOpus,
				Int32(format.channelCount),
				&error.rawValue
			)
			if error != .ok {
				throw error
			}
		}

		deinit {
			opus_encoder_destroy(encoder)
		}

		public func reset() throws {
			// A custom frame size means we're using opus custom
			guard customFrameSize == nil else { return }
			let error = Opus.Error(opus_encoder_init(encoder, Int32(format.sampleRate), Int32(format.channelCount), application.rawValue))
			if error != .ok {
				throw error
			}
		}
	}
}

// MARK: Public encode methods

public extension Opus.Encoder {
	func encode(_ input: AVAudioPCMBuffer, to output: inout Data) throws -> Int {
		output.count = try output.withUnsafeMutableBytes {
			try encode(input, to: $0)
		}
		return output.count
	}

	func encode(_ input: AVAudioPCMBuffer, compressedSize: Int) throws -> Data {
		var compressed = Data(repeating: 0, count: compressedSize)
		compressed.count = try compressed.withUnsafeMutableBytes(
			{ try encode(input, to: $0, compressedSize: compressedSize) }
		)
		return compressed
	}

	func encode(_ input: AVAudioPCMBuffer, to output: inout [UInt8],
	            compressedSize _: Int? = nil) throws -> Int
	{
		try output.withUnsafeMutableBufferPointer {
			try encode(input, to: $0)
		}
	}

	func encode(_ input: AVAudioPCMBuffer, to output: UnsafeMutableRawBufferPointer,
	            compressedSize _: Int? = nil) throws -> Int
	{
		let output = UnsafeMutableBufferPointer(start: output.baseAddress!.bindMemory(to: UInt8.self, capacity: output.count), count: output.count)
		return try encode(input, to: output)
	}

	func encode(_ input: AVAudioPCMBuffer, to output: UnsafeMutableBufferPointer<UInt8>,
	            compressedSize: Int? = nil) throws -> Int
	{
		guard input.format.sampleRate == format.sampleRate, input.format.channelCount == format.channelCount else {
			throw Opus.Error.badArgument
		}
		switch format.commonFormat {
		case .pcmFormatInt16:
			let input = UnsafeBufferPointer(start: input.int16ChannelData![0],
			                                count: Int(input.frameLength * format.channelCount))
			return try encode(input, to: output, compressedSize: compressedSize)
		case .pcmFormatFloat32:
			let input = UnsafeBufferPointer(start: input.floatChannelData![0],
			                                count: Int(input.frameLength * format.channelCount))
			return try encode(input, to: output, compressedSize: compressedSize)
		default:
			throw Opus.Error.badArgument
		}
	}
}

// MARK: private encode methods

extension Opus.Encoder {
	private func encode(_ input: UnsafeBufferPointer<Int16>,
	                    to output: UnsafeMutableBufferPointer<UInt8>,
	                    compressedSize: Int? = nil) throws -> Int
	{
		var encodedSize: Int32 = 0
		if let customSize = compressedSize, let frameSize = customFrameSize {
			// Custom mode
			encodedSize = opus_custom_encode(
				encoder,
				input.baseAddress!,
				frameSize,
				output.baseAddress!,
				Int32(customSize)
			)
		} else {
			encodedSize = opus_encode(
				encoder,
				input.baseAddress!,
				Int32(input.count) / Int32(format.channelCount),
				output.baseAddress!,
				Int32(output.count)
			)
		}
		if encodedSize < 0 {
			throw Opus.Error(encodedSize)
		}
		return Int(encodedSize)
	}

	private func encode(_ input: UnsafeBufferPointer<Float32>,
	                    to output: UnsafeMutableBufferPointer<UInt8>,
	                    compressedSize: Int? = nil) throws -> Int
	{
		var encodedSize: Int32 = 0
		if let customSize = compressedSize, let frameSize = customFrameSize {
			// Custom mode
			encodedSize = opus_custom_encode_float(
				encoder,
				input.baseAddress!,
				frameSize,
				output.baseAddress!,
				Int32(customSize)
			)
		} else {
			encodedSize = opus_encode_float(
				encoder,
				input.baseAddress!,
				Int32(input.count) / Int32(format.channelCount),
				output.baseAddress!,
				Int32(output.count)
			)
		}
		if encodedSize < 0 {
			throw Opus.Error(encodedSize)
		}
		return Int(encodedSize)
	}
}
