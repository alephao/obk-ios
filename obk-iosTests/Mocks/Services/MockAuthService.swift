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
    
    var signUpResult: Observable<Volunteer?> = .just(nil)
    func signup(firstName: String,
                lastName: String,
                email: String,
                password: String,
                contactNumber: String,
                dateOfBirth: String,
                wwccn: String?,
                subNewsletter: Bool)
        -> Observable<Volunteer?> {
        return signUpResult
    }
}
