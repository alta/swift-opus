extension Opus {
	public struct Application: Equatable, RawRepresentable, ExpressibleByIntegerLiteral, Sendable {
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

		public init<T: BinaryInteger>(_ value: T) {
			self.init(rawValue: IntegerLiteralType(value))
		}
	}
}
