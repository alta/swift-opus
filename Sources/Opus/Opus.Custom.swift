import AVFoundation
import Copus
import Foundation

public extension Opus {
  class Custom {
    private let opusCustomMode: OpaquePointer
    let encoder: OpaquePointer
    let decoder: OpaquePointer
    
    public init(format: AVAudioFormat,
                application: Application = .audio,
                frameSize: UInt32 = 128) throws {
      if !format.isValidOpusPCMFormat {
        throw Opus.Error.badArgument
      }
      
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
      opus_custom_decoder_destroy(decoder)
      opus_custom_encoder_destroy(encoder)
      opus_custom_mode_destroy(opusCustomMode)
    }
  }
}

