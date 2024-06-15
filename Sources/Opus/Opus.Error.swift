extension Opus {
	public struct Error: Swift.Error, Equatable, RawRepresentable, ExpressibleByIntegerLiteral {
		public typealias IntegerLiteralType = Int32
		public var rawValue: IntegerLiteralType

		public static let ok = Self(OPUS_OK)
		public static let badArgument = Self(OPUS_BAD_ARG)
		public static let bufferTooSmall = Self(OPUS_BUFFER_TOO_SMALL)
		public static let internalError = Self(OPUS_INTERNAL_ERROR)
		public static let invalidPacket = Self(OPUS_INVALID_PACKET)
		public static let unimplemented = Self(OPUS_UNIMPLEMENTED)
		public static let invalidState = Self(OPUS_INVALID_STATE)
		public static let allocationFailure = Self(OPUS_ALLOC_FAIL)

		public init(rawValue: IntegerLiteralType) {
			self.rawValue = rawValue
		}

		public init(integerLiteral value: IntegerLiteralType) {
			self.init(rawValue: value)
		}

		public init<T: BinaryInteger>(_ value: T) {
			self.init(rawValue: IntegerLiteralType(value))
		}
	}
}
