import Argo
import Curry
import Foundation
import Runes

public struct JoinEventEnvelope {
    let success: Bool
}

extension JoinEventEnvelope: Decodable {
    public static func decode(_ j: JSON) -> Decoded<JoinEventEnvelope> {
        let create = curry(JoinEventEnvelope.init)
        return create
            <^> j <|  "success"
    }
}
