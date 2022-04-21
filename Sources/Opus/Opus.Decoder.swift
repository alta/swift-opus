import AVFoundation
import Copus

public extension Opus {
	class Decoder {
		let format: AVAudioFormat
		let decoder: OpaquePointer
		let customFrameSize: Int32?

		public init(format: AVAudioFormat, application _: Application = .audio) throws {
			customFrameSize = nil
			if !format.isValidOpusPCMFormat {
				throw Opus.Error.badArgument
			}

			self.format = format

			// Initialize Opus decoder
			var error: Opus.Error = .ok
			decoder = opus_decoder_create(Int32(format.sampleRate), Int32(format.channelCount), &error.rawValue)
			if error != .ok {
				throw error
			}
		}

		public init(customOpus: OpaquePointer,
		            format: AVAudioFormat,
		            customFrameSize: UInt32) throws
		{
			self.customFrameSize = Int32(customFrameSize)
			if !format.isValidOpusPCMFormat {
				throw Opus.Error.badArgument
			}

			self.format = format

			// Initialize Opus decoder
			var error: Opus.Error = .ok
			decoder = opus_custom_decoder_create(customOpus,
			                                     Int32(format.channelCount),
			                                     &error.rawValue)
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
	}
}

// MARK: Public decode methods

public extension Opus.Decoder {
	func decode(_ input: Data,
	            compressedPacketSize: Int32? = nil,
	            sampleMultiplier: Int32 = 1) throws -> AVAudioPCMBuffer
	{
		try input.withUnsafeBytes {
			var output: AVAudioPCMBuffer
			let input = $0.bindMemory(to: UInt8.self)
			if compressedPacketSize != nil, let frameSize = customFrameSize {
				output = AVAudioPCMBuffer(
					pcmFormat: format,
					frameCapacity: AVAudioFrameCount(frameSize * sampleMultiplier)
				)!
			} else {
				let sampleCount = opus_decoder_get_nb_samples(decoder, input.baseAddress!, Int32($0.count))
				if sampleCount < 0 {
					throw Opus.Error(sampleCount)
				}
				output = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(sampleCount))!
			}

			try decode(input, to: output, packetSize: compressedPacketSize)
			return output
		}
	}

	func decode(_ input: UnsafeBufferPointer<UInt8>, to output: AVAudioPCMBuffer,
	            packetSize: Int32? = nil) throws
	{
		let decodedCount: Int
		switch output.format.commonFormat {
		case .pcmFormatInt16:
			let output = UnsafeMutableBufferPointer(start: output.int16ChannelData![0], count: Int(output.frameCapacity))
			decodedCount = try decode(input, to: output, packetSize: packetSize)
		case .pcmFormatFloat32:
			let output = UnsafeMutableBufferPointer(start: output.floatChannelData![0], count: Int(output.frameCapacity))
			decodedCount = try decode(input, to: output, packetSize: packetSize)
		default:
			throw Opus.Error.badArgument
		}
		if decodedCount < 0 {
			throw Opus.Error(decodedCount)
		}
		output.frameLength = AVAudioFrameCount(decodedCount)
	}
}

// MARK: Private decode methods

extension Opus.Decoder {
	private func decode(_ input: UnsafeBufferPointer<UInt8>,
	                    to output: UnsafeMutableBufferPointer<Int16>,
	                    packetSize: Int32?) throws -> Int
	{
		var decodedCount: Int32 = 0
		if let size = packetSize {
			decodedCount = opus_custom_decode(
				decoder,
				input.isEmpty ? nil : input.baseAddress,
				size,
				output.baseAddress!,
				Int32(output.count)
			)
		} else {
			decodedCount = opus_decode(
				decoder,
				input.isEmpty ? nil : input.baseAddress,
				Int32(input.count),
				output.baseAddress!,
				Int32(output.count),
				0
			)
		}
		if decodedCount < 0 {
			throw Opus.Error(decodedCount)
		}
		return Int(decodedCount)
	}

	private func decode(_ input: UnsafeBufferPointer<UInt8>,
	                    to output: UnsafeMutableBufferPointer<Float32>,
	                    packetSize: Int32?) throws -> Int
	{
		var decodedCount: Int32 = 0
		if let size = packetSize {
			decodedCount = opus_custom_decode_float(
				decoder,
				input.isEmpty ? nil : input.baseAddress,
				size,
				output.baseAddress!,
				Int32(output.count)
			)
		} else {
			decodedCount = opus_decode_float(
				decoder,
				input.isEmpty ? nil : input.baseAddress,
				Int32(input.count),
				output.baseAddress!,
				Int32(output.count),
				0
			)
		}
		if decodedCount < 0 {
			throw Opus.Error(decodedCount)
		}
		return Int(decodedCount)
	}
}
