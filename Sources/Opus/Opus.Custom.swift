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
    let encoder: OpaquePointer
    let decoder: OpaquePointer
    private let format: AVAudioFormat
    public let frameSize: Int32
    
    public init(format: AVAudioFormat,
                application: Application = .audio,
                frameSize: UInt32 = 128) throws {
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
        &error.rawValue) else { throw error }
      opusCustomMode = customMode
      
      // Create custom encoder
      guard let opusEncoder = opus_custom_encoder_create(
        customMode,
        Int32(format.channelCount),
        &error.rawValue) else { throw error }
      
      encoder = opusEncoder
      
      // Create custom decoder
      guard let opusDecoder = opus_custom_decoder_create(
        customMode,
        Int32(format.channelCount),
        &error.rawValue) else { throw error }
      decoder = opusDecoder
    }
    
    deinit {
      opus_encoder_destroy(encoder)
      opus_decoder_destroy(decoder)
      opus_custom_mode_destroy(opusCustomMode)
    }
    
    ///
    /// Wrapper onto the opus_custom_encoder_ctl function
    /// - Parameter request The Opus CTL to change
    /// - Parameter value The value to set it to
    ///
    /// - Returns Opus.Error code raw type
    public func encoderCtl(request: Int32, value: Int32) -> Opus.Error.RawValue {
      return opus_custom_encoder_ctl_wrapper(encoder, request, value)
    }
    
    ///
    /// Encode a PCM buffer to data using the custom mode configuration and max size
    /// - parameter avData Audio data to compress
    /// - parameter compressedSize Opus packet size to compress to
    /// - Returns Data containing the Opus packet
    public func encode(_ avData: AVAudioPCMBuffer,
                       compressedSize: Int) throws -> Data {
      var compressed = Data(repeating: 0, count: compressedSize)
      compressed.count = try compressed.withUnsafeMutableBytes(
        { try encode(avData, to: $0, compressedSize: compressedSize) }
      )
      return compressed
    }
    
    private func encode(_ input: AVAudioPCMBuffer,
                        to output: inout [UInt8],
                        compressedSize: Int) throws -> Int {
      try output.withUnsafeMutableBufferPointer {
        try encode(input, to: $0, compressedSize: compressedSize)
      }
    }
    
    private func encode(_ input: AVAudioPCMBuffer,
                        to output: UnsafeMutableRawBufferPointer,
                        compressedSize: Int) throws -> Int {
      let output = UnsafeMutableBufferPointer(
        start: output.baseAddress!.bindMemory(
          to: UInt8.self, capacity: output.count),
        count: output.count)
      return try encode(input, to: output, compressedSize: compressedSize)
    }
    
    private func encode(_ input: AVAudioPCMBuffer,
                        to output: UnsafeMutableBufferPointer<UInt8>,
                        compressedSize: Int) throws -> Int {
      guard input.format.sampleRate == format.sampleRate,
            input.format.channelCount == format.channelCount else {
        throw Opus.Error.badArgument
      }
      
      switch format.commonFormat {
      case .pcmFormatInt16:
        let input = UnsafeBufferPointer(
          start: input.int16ChannelData![0],
          count: Int(input.frameLength * format.channelCount))
        return try encode(input, to: output, compressedSize: compressedSize)
        
      case .pcmFormatFloat32:
        let input = UnsafeBufferPointer(
          start: input.floatChannelData![0],
          count: Int(input.frameLength * format.channelCount))
        return try encode(input, to: output, compressedSize: compressedSize)
        
      default:
        throw Opus.Error.badArgument
      }
    }
    
    private func encode(_ input: UnsafeBufferPointer<Int16>,
                        to output: UnsafeMutableBufferPointer<UInt8>,
                        compressedSize: Int) throws -> Int {
      let encodedSize = opus_custom_encode(
        encoder,
        input.baseAddress!,
        frameSize,
        output.baseAddress!,
        Int32(compressedSize)
      )
      
      if encodedSize < 0 {
        throw Opus.Error(encodedSize)
      }
      return Int(encodedSize)
    }
    
    private func encode(_ input: UnsafeBufferPointer<Float32>,
                        to output: UnsafeMutableBufferPointer<UInt8>,
                        compressedSize: Int) throws -> Int {
      let encodedSize = opus_custom_encode_float(
        encoder,
        input.baseAddress!,
        frameSize,
        output.baseAddress!,
        Int32(compressedSize)
      )
      if encodedSize < 0 {
        throw Opus.Error(encodedSize)
      }
      return Int(encodedSize)
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
                       sampleMultiplier: Int32 = 1) throws -> AVAudioPCMBuffer {
      guard data.isEmpty || data.count == compressedPacketSize else {
        throw Opus.Error.bufferTooSmall
      }
      
      return try data.withUnsafeBytes {
        let input = $0.bindMemory(to: UInt8.self)
        
        let output = AVAudioPCMBuffer(
          pcmFormat: format,
          frameCapacity: AVAudioFrameCount(frameSize * sampleMultiplier))!
        try decode(input, to: output, packetSize: compressedPacketSize)
        
        return output
      }
    }
    
    private func decode(_ input: UnsafeBufferPointer<UInt8>,
                        to output: AVAudioPCMBuffer,
                        packetSize: Int32
    ) throws {
      let decodedCount: Int
      
      switch output.format.commonFormat {
      case .pcmFormatInt16:
        let output = UnsafeMutableBufferPointer(
          start: output.int16ChannelData![0],
          count: Int(output.frameCapacity)
        )
        decodedCount = try decode(input, to: output, packetSize: packetSize)
        
      case .pcmFormatFloat32:
        let output = UnsafeMutableBufferPointer(
          start: output.floatChannelData![0],
          count: Int(output.frameCapacity)
        )
        decodedCount = try decode(input, to: output, packetSize: packetSize)
      default:
        throw Opus.Error.badArgument
      }
      
      if decodedCount < 0 {
        throw Opus.Error(decodedCount)
      }
      output.frameLength = AVAudioFrameCount(decodedCount)
    }
    
    private func decode(_ input: UnsafeBufferPointer<UInt8>,
                        to output: UnsafeMutableBufferPointer<Int16>,
                        packetSize: Int32) throws -> Int {
      let decodedCount = opus_custom_decode(
        decoder,
        input.isEmpty ? nil : input.baseAddress,
        packetSize,
        output.baseAddress!,
        Int32(output.count)
      )
      if decodedCount < 0 {
        throw Opus.Error(decodedCount)
      }
      return Int(decodedCount)
    }
    
    private func decode(_ input: UnsafeBufferPointer<UInt8>,
                        to output: UnsafeMutableBufferPointer<Float32>,
                        packetSize: Int32) throws -> Int {
      let decodedCount = opus_custom_decode_float(
        decoder,
        input.isEmpty ? nil : input.baseAddress,
        packetSize,
        output.baseAddress!,
        Int32(output.count)
      )
      if decodedCount < 0 {
        throw Opus.Error(decodedCount)
      }
      return Int(decodedCount)
    }
  }
}

