import Argo
import Curry
import Foundation
import Runes

public struct ErrorEnvelope {
    let errors: [String]
}

extension ErrorEnvelope: Decodable {
    public static func decode(_ j: JSON) -> Decoded<ErrorEnvelope> {
        let create = curry(ErrorEnvelope.init)
        return create
            <^> j <|| "errors"
    }
}
