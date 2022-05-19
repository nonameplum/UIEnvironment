import Foundation

extension Locale: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(identifier: value)
    }
}
