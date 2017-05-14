import RxSwift

final class MockUserService: UserServiceType {
    var currentUser: Observable<Volunteer?> {
        return .just(nil)
    }
    
    func updateCurrentUser(_ volunteer: Volunteer?) {
        
    }
}
