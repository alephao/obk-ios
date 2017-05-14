import RxSwift

final class MockRegistrationService: RegistrationServiceType {
    func signup(firstName: String,
                lastName: String,
                email: String,
                password: String,
                contactNumber: String,
                dateOfBirth: String,
                wwccn: String?,
                subNewsletter: Bool) -> Observable<Void> {
        return .just(())
    }
}
