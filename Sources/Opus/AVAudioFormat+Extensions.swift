import AVFoundation

public extension AVAudioFormat {
	var isValidOpusPCMFormat: Bool {
		switch sampleRate {
		case .opus8khz, .opus12khz, .opus16khz, .opus24khz, .opus48khz:
			break
		default:
			return false
		}

		switch channelCount {
		case 1, 2:
			break
		default:
			return false
		}

		if channelCount != 1, !isInterleaved {
			return false
		}

		if commonFormat == .pcmFormatInt16 || commonFormat == .pcmFormatFloat32 {
			return true
		}

		let desc = streamDescription.pointee
		if desc.mFormatID != kAudioFormatLinearPCM {
			return false
		}
		if desc.mFormatFlags & kLinearPCMFormatFlagIsSignedInteger != 0, desc.mBitsPerChannel != 16 {
			return false
		}
		if desc.mFormatFlags & kLinearPCMFormatFlagIsFloat != 0, desc.mBitsPerChannel != 32 {
			return false
		}

		return true
	}
}
