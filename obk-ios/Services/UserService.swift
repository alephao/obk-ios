import RxSwift

protocol UserServiceType: class {
    var currentUser: Observable<Volunteer?> { get }
    
    func updateCurrentUser(_ volunteer: Volunteer?)
}

final class UserService: BaseService, UserServiceType {
    
    fileprivate let userSubject = ReplaySubject<Volunteer?>.create(bufferSize: 1)
    lazy var currentUser: Observable<Volunteer?> = self.userSubject.asObservable()
        .startWith(nil)
        .shareReplay(1)
    
    func updateCurrentUser(_ volunteer: Volunteer?) {
        userSubject.onNext(volunteer)
    }
    
}
