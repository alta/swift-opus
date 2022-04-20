import AVFoundation
import Copus
import Copuswrapper
import Foundation

public extension Opus {
	///
	/// Implements a custom opus encoder / decoder.
	/// Custom implementations can have non-standard frame sizes
	///
	final class Custom {
		private let opusCustomMode: OpaquePointer
		let encoder: Opus.Encoder
		let decoder: Opus.Decoder
		private let format: AVAudioFormat
		public let frameSize: Int32

		public init(format: AVAudioFormat,
		            application _: Application = .audio,
		            frameSize: UInt32 = 128) throws
		{
			if !format.isValidOpusPCMFormat {
				throw Opus.Error.badArgument
			}
			self.format = format
			self.frameSize = Int32(frameSize)

			var error: Opus.Error = .ok

			// Create custom parameters
			guard let customMode = opus_custom_mode_create(
				Int32(format.sampleRate),
				Int32(frameSize),
				&error.rawValue
			) else { throw error }
			opusCustomMode = customMode

			// Create custom encoder
			encoder = try Opus.Encoder(customOpus: opusCustomMode,
			                           format: format,
			                           frameSize: frameSize)
			// Create custom decoder
			decoder = try Opus.Decoder(customOpus: opusCustomMode,
			                           format: format,
			                           frameSize: frameSize)
		}

		deinit {
			opus_custom_mode_destroy(opusCustomMode)
		}

		///
		/// Wrapper onto the opus_custom_encoder_ctl function
		/// https://www.opus-codec.org/docs/opus_api-1.3.1/group__opus__encoderctls.html
		/// - Parameter request The Opus CTL to change
		/// - Parameter value The value to set it to
		///
		/// - Returns Opus.Error code
		public func encoderCtl(request: Int32, value: Int32) -> Opus.Error {
			Opus.Error(
				rawValue: opus_custom_encoder_ctl_wrapper(encoder.encoder, request, value)
			)
		}

		///
		/// Encode a PCM buffer to data using the custom mode configuration and max size
		/// - parameter avData Audio data to compress
		/// - parameter compressedSize Opus packet size to compress to
		/// - Returns Data containing the Opus packet
		public func encode(_ avData: AVAudioPCMBuffer,
		                   compressedSize: Int) throws -> Data
		{
			try encoder.encode(avData, compressedSize: compressedSize)
		}

		///
		/// Decode an opus packet
		/// If the data is empty, it is treated as a dropped packet
		/// - Parameter data Compressed data
		/// - Parameter compressedPacketSize Number of bytes of data
		/// - Parameter sampleMultiplier Frame size multiplier if greater than one
		/// - Returns Uncompressed audio buffer
		public func decode(_ data: Data,
		                   compressedPacketSize: Int32,
		                   sampleMultiplier: Int32 = 1) throws -> AVAudioPCMBuffer
		{
			guard data.isEmpty || data.count == compressedPacketSize else {
				throw Opus.Error.bufferTooSmall
			}
			return try decoder.decode(data,
			                          compressedPacketSize: compressedPacketSize,
			                          sampleMultiplier: sampleMultiplier)
		}
	}
}
