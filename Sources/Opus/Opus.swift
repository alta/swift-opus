import AVFoundation
import CoreAudio

@_exported import Copus

public enum Opus: CaseIterable {}

public extension Opus {
	struct Error: Swift.Error, Equatable, RawRepresentable, ExpressibleByIntegerLiteral {
		public typealias IntegerLiteralType = Int32
		public var rawValue: IntegerLiteralType

		public static let ok = Self(OPUS_OK)
		public static let badArg = Self(OPUS_BAD_ARG)
		public static let bufferTooSmall = Self(OPUS_BUFFER_TOO_SMALL)
		public static let internalError = Self(OPUS_INTERNAL_ERROR)
		public static let invalidPacket = Self(OPUS_INVALID_PACKET)
		public static let unimplemented = Self(OPUS_UNIMPLEMENTED)
		public static let invalidState = Self(OPUS_INVALID_STATE)
		public static let allocFail = Self(OPUS_ALLOC_FAIL)

		public init(rawValue: IntegerLiteralType) {
			self.rawValue = rawValue
		}

		public init(integerLiteral value: IntegerLiteralType) {
			self.init(rawValue: value)
		}

		public init(_ value: IntegerLiteralType) {
			self.init(rawValue: value)
		}
	}
}

public extension Opus {
	struct Application: Equatable, RawRepresentable, ExpressibleByIntegerLiteral {
		public typealias IntegerLiteralType = Int32
		public var rawValue: IntegerLiteralType

		public static let audio = Self(OPUS_APPLICATION_AUDIO)
		public static let voip = Self(OPUS_APPLICATION_VOIP)
		public static let restrictedLowDelay = Self(OPUS_APPLICATION_RESTRICTED_LOWDELAY)

		public init(rawValue: IntegerLiteralType) {
			self.rawValue = rawValue
		}

		public init(integerLiteral value: IntegerLiteralType) {
			self.init(rawValue: value)
		}

		public init(_ value: IntegerLiteralType) {
			self.init(rawValue: value)
		}
	}
}

public extension Opus {
	static func isValidFormat(_ format: AVAudioFormat) -> Bool {
		switch format.sampleRate {
		case .opus8khz, .opus12khz, .opus16khz, .opus24khz, .opus48khz:
			break
		default:
			return false
		}

		switch format.channelCount {
		case 1, 2:
			break
		default:
			return false
		}

		if format.channelCount != 1, !format.isInterleaved {
			return false
		}

		if format.commonFormat == .pcmFormatInt16 || format.commonFormat == .pcmFormatFloat32 {
			return true
		}

		let desc = format.streamDescription.pointee
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
