import Argo
import Curry
import Foundation
import Runes

public struct AuthEnvelope {
    let data: AuthEnvelope.Data
    
    public struct Data {
        let volunteer: Volunteer
    }
}

extension AuthEnvelope: Decodable {
    public static func decode(_ j: JSON) -> Decoded<AuthEnvelope> {
        let create = curry(AuthEnvelope.init)
        return create
            <^> j <| "data"
    }
}

extension AuthEnvelope.Data: Decodable {
    public static func decode(_ j: JSON) -> Decoded<AuthEnvelope.Data> {
        let create = curry(AuthEnvelope.Data.init)
        return create
            <^> j <| "volunteer"
    }
}
