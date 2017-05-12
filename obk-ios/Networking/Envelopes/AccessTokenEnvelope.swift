import Argo
import Curry
import Foundation
import Runes

public struct AccessTokenEnvelope {
    let accessToken: String
    let tokenType: String
    let client: String
    let expiry: String
    let uid: String
    
    func toDictionary() -> [String: String] {
        return [
        "Access-Token": accessToken,
        "Token-Type": tokenType,
        "Client": client,
        "Expiry": expiry,
        "Uid": uid
        ]
    }
}

extension AccessTokenEnvelope: Decodable {
    public static func decode(_ j: JSON) -> Decoded<AccessTokenEnvelope> {
        let create = curry(AccessTokenEnvelope.init)
        return create
            <^> j <| "Access-Token"
            <*> j <| "Token-Type"
            <*> j <| "Client"
            <*> j <| "Expiry"
            <*> j <| "Uid"
    }
}
