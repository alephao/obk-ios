import Argo
import Moya
import KeychainAccess
import RxSwift

struct AccessToken {
    let accessToken: String
    let expiry: String
    let client: String
    let tokenType: String
    let uid: String
    
    func asDict() -> [String: String] {
        return [
            "access-token": accessToken,
            "expiry": expiry,
            "client": client,
            "token-type": tokenType,
            "uid": uid,
        ]
    }
}

protocol AuthServiceType: class {
    var currentAccessToken: AccessToken? { get }
    
    func signIn(email: String, password: String) -> Observable<Volunteer?>
    
    func logout()
}

final class AuthService: BaseService, AuthServiceType {
    
    fileprivate let keychain = Keychain(service: "au.org.obk.obk-ios")
    private(set) var currentAccessToken: AccessToken?
    
    override init(provider: ServiceProviderType) {
        super.init(provider: provider)
        self.currentAccessToken = self.loadAccessToken()
    }
    
    func signIn(email: String, password: String) -> Observable<Volunteer?> {
//        self?.provider.userService.updateCurrentUser(volunteer)
        return self.provider.networking.request(.signin(email: email, password: password))
            .do(onNext: { [weak self] response in self?.extractToken(response) })
            .mapJSON()
            .map { [weak self] anyJson in
                let json = JSON(anyJson)
                do {
                    let decoded = AuthEnvelope.decode(json)
                    let dematerialized = try decoded.dematerialize()
                    let volunteer = dematerialized.data.volunteer
                    self?.provider.userService.updateCurrentUser(volunteer)
                    return volunteer
                } catch {
                    return nil
                }
        }
    }
    
    func logout() {
        self.currentAccessToken = nil
        self.deleteAccessToken()
    }
    
    fileprivate func extractToken(_ response: Response) {
        if let r = response.response as? HTTPURLResponse {
            let headers = r.allHeaderFields
            
            if let accessToken = headers["access-token"] as? String,
                let client = headers["client"] as? String,
                let expiry = headers["expiry"] as? String,
                let tokenType = headers["token-type"] as? String,
                let uid = headers["uid"] as? String{
                
                let accessToken = AccessToken(accessToken: accessToken,
                                              expiry: expiry,
                                              client: client,
                                              tokenType: tokenType,
                                              uid: uid)
                
                
                self.currentAccessToken = accessToken
                try? self.save(accessToken)
            }
        }
    }
    
    fileprivate func save(_ accessToken: AccessToken) throws {
        try self.keychain.set(accessToken.accessToken, key: "access_token")
        try self.keychain.set(accessToken.expiry , key: "expiry")
        try self.keychain.set(accessToken.client , key: "client")
        try self.keychain.set(accessToken.tokenType , key: "token_type")
        try self.keychain.set(accessToken.uid , key: "uid")
    }
    
    fileprivate func loadAccessToken() -> AccessToken? {
        guard let accessToken = self.keychain["access_token"],
            let expiry = self.keychain["expiry"],
            let client = self.keychain["client"],
            let tokenType = self.keychain["token_type"],
            let uid = self.keychain["uid"]
            else { return nil }
        return AccessToken(accessToken: accessToken,
                           expiry: expiry,
                           client: client,
                           tokenType: tokenType,
                           uid: uid)
    }
    
    fileprivate func deleteAccessToken() {
        try? self.keychain.remove("access_token")
        try? self.keychain.remove("expiry")
        try? self.keychain.remove("client")
        try? self.keychain.remove("token_type")
        try? self.keychain.remove("uid")
    }
}
