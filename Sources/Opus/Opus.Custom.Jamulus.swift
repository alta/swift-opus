//
//  File.swift
//  
//
//  Created by Emlyn Bolton on 2022-03-18.
//

import Copuswrapper
import Foundation

public extension Opus.Custom {
  
  ///
  /// Sets up jamulus-specific parts of the custom opus implementation
  ///
  func configureForJamulus() throws {
    var error: Opus.Error = .ok
    
    // Disable variable bit rates
    error.rawValue = opus_custom_encoder_ctl_wrapper(
      encoder,
      OPUS_SET_VBR_REQUEST, 0)
    guard error == .ok else { throw error }
 
    // Request low latency
    error.rawValue = opus_custom_encoder_ctl_wrapper(
      encoder,
      OPUS_SET_APPLICATION_REQUEST, OPUS_APPLICATION_RESTRICTED_LOWDELAY)
    guard error == .ok else { throw error }
    
    switch frameSize {
    case 64:
      // Adjust PLC behaviour for better drop out handling
      error.rawValue = opus_custom_encoder_ctl_wrapper(
        encoder,
        OPUS_SET_PACKET_LOSS_PERC_REQUEST, 35)
      guard error == .ok else { throw error }
      
    case 128:
      // Set complexity for 128 sample frame size
      error.rawValue = opus_custom_encoder_ctl_wrapper(
        encoder,
        OPUS_SET_COMPLEXITY_REQUEST, 1)
      guard error == .ok else { throw error }
      
    default:
      break
    }
  }
}
