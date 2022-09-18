import Foundation

extension DefaultStringInterpolation {

    mutating func appendInterpolation<T>(optional: T?) {
        appendInterpolation(optional.map({"\($0)"}) ?? "␀")
    }
}

extension Optional {

    var logable: String { self.map({"\($0)"}) ?? "␀" }
}
