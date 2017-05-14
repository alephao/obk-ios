import RxSwift

final class MockAuthService: AuthServiceType {
    var currentAccessToken: AccessToken? {
        return nil
    }
    
    func logout() { }
    
    var signInResult: Observable<Volunteer?> = .just(nil)
    func signIn(email: String, password: String) -> Observable<Volunteer?> {
        return signInResult
    }
}
