import AVFoundation

extension AVAudioFormat {
	public enum OpusPCMFormat {
		case int16
		case float32
	}

	public convenience init?(opusPCMFormat: OpusPCMFormat, sampleRate: Double, channels: AVAudioChannelCount) {
		switch opusPCMFormat {
		case .int16:
			self.init(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: channels, interleaved: channels != 1)
		case .float32:
			self.init(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: channels, interleaved: channels != 1)
		}
		if !isValidOpusPCMFormat {
			return nil
		}
	}

	public var isValidOpusPCMFormat: Bool {
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
