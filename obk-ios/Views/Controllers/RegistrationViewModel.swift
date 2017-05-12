import Argo
import Moya
import RxCocoa
import RxSwift
import UIKit

protocol RegistrationViewModelType: class {
    // MARK: Inputs
    var contactNumberTextFieldDidChange: PublishSubject<String> { get }
    var contactNumberTextFieldDidReturn: PublishSubject<Void> { get }
    var dateOfBirthDidChange: PublishSubject<Date> { get }
    var dateOfBirthTextFieldDidReturn: PublishSubject<Void> { get }
    var didTapRegisterButton: PublishSubject<Void> { get }
    var emailTextFieldDidChange: PublishSubject<String> { get }
    var emailTextFieldDidReturn: PublishSubject<Void> { get }
    var firstNameTextFieldDidChange: PublishSubject<String> { get }
    var firstNameTextFieldDidReturn: PublishSubject<Void> { get }
    var lastNameTextFieldDidChange: PublishSubject<String> { get }
    var lastNameTextFieldDidReturn: PublishSubject<Void> { get }
    var passwordTextFieldDidChange: PublishSubject<String> { get }
    var passwordTextFieldDidReturn: PublishSubject<Void> { get }
    var wwccnTextFieldDidChange: PublishSubject<String> { get }
    var wwccnTextFieldDidReturn: PublishSubject<Void> { get }
    
    // MARK: Outputs
    var dateOfBirth: Driver<String> { get }
    var focusOnContactNumberTextField: Observable<Void> { get }
    var focusOnDateOfBirthTextField: Observable<Void> { get }
    var focusOnEmailTextField: Observable<Void> { get }
    var focusOnFirstNameTextField: Observable<Void> { get }
    var focusOnLastNameTextField: Observable<Void> { get }
    var focusOnPasswordTextField: Observable<Void> { get }
    var focusOnWwccnTextField: Observable<Void> { get }
    var wwccnIsHidden: Observable<Bool> { get }
}

final class RegistrationViewModel: RegistrationViewModelType {
    
    // MARK: Inputs
    let contactNumberTextFieldDidChange: PublishSubject<String> = .init()
    let contactNumberTextFieldDidReturn: PublishSubject<Void> = .init()
    let dateOfBirthDidChange: PublishSubject<Date> = .init()
    let dateOfBirthTextFieldDidReturn: PublishSubject<Void> = .init()
    let didTapRegisterButton: PublishSubject<Void> = .init()
    let emailTextFieldDidChange: PublishSubject<String> = .init()
    let emailTextFieldDidReturn: PublishSubject<Void> = .init()
    let firstNameTextFieldDidChange: PublishSubject<String> = .init()
    let firstNameTextFieldDidReturn: PublishSubject<Void> = .init()
    let lastNameTextFieldDidChange: PublishSubject<String> = .init()
    let lastNameTextFieldDidReturn: PublishSubject<Void> = .init()
    let passwordTextFieldDidChange: PublishSubject<String> = .init()
    let passwordTextFieldDidReturn: PublishSubject<Void> = .init()
    let wwccnTextFieldDidChange: PublishSubject<String> = .init()
    let wwccnTextFieldDidReturn: PublishSubject<Void> = .init()
    
    // MARK: Outputs
    let dateOfBirth: SharedSequence<DriverSharingStrategy, String>
    let focusOnContactNumberTextField: Observable<Void>
    let focusOnDateOfBirthTextField: Observable<Void>
    let focusOnEmailTextField: Observable<Void>
    let focusOnFirstNameTextField: Observable<Void>
    let focusOnLastNameTextField: Observable<Void>
    let focusOnPasswordTextField: Observable<Void>
    let focusOnWwccnTextField: Observable<Void>
    let wwccnIsHidden: Observable<Bool>
    
    init(provider: ServiceProviderType) {
        let hideWwccn = dateOfBirthDidChange
            .map { date -> Bool in
                let calendar = Calendar(identifier: .gregorian)
                let today = Date()
                guard let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: today) else {
                    return false
                }
                return eighteenYearsAgo < date
            }
            .startWith(true)
            .shareReplayLatestWhileConnected()
        
        let dateFormatter = DateFormatter(dateFormat: "dd/MM/yyyy")
        
        self.dateOfBirth = dateOfBirthDidChange
            .map(dateFormatter.string)
            .asDriver(onErrorJustReturn: "")
        
        self.focusOnContactNumberTextField = passwordTextFieldDidReturn
            .asObservable()
            .observeOn(MainScheduler.instance)
        
        self.focusOnDateOfBirthTextField = contactNumberTextFieldDidReturn
            .asObservable()
            .observeOn(MainScheduler.instance)
        
        self.focusOnEmailTextField = lastNameTextFieldDidReturn
            .asObservable()
            .observeOn(MainScheduler.instance)
        
        self.focusOnFirstNameTextField = Observable.just(()) // Tey
        
        self.focusOnLastNameTextField = firstNameTextFieldDidReturn
            .asObservable()
            .observeOn(MainScheduler.instance)
        
        self.focusOnPasswordTextField = emailTextFieldDidReturn
            .asObservable()
            .observeOn(MainScheduler.instance)
        
        self.focusOnWwccnTextField = dateOfBirthTextFieldDidReturn
            .withLatestFrom(hideWwccn)
            .filter { !$0 }
            .map { _ in () }
            .observeOn(MainScheduler.instance)
        
        self.wwccnIsHidden = hideWwccn
            .observeOn(MainScheduler.instance)
        
        let dateFormatterF = DateFormatter(dateFormat: "yyyy-MM-dd")
        
        let signup = Observable.combineLatest(firstNameTextFieldDidChange,
                                              lastNameTextFieldDidChange,
                                              emailTextFieldDidChange,
                                              passwordTextFieldDidChange,
                                              contactNumberTextFieldDidChange,
                                              dateOfBirthDidChange,
                                              wwccnTextFieldDidChange) { (
                                                firstName,
                                                lastName,
                                                email,
                                                password,
                                                contactNumber,
                                                dob,
                                                wwccn
                                                ) in
                                                return (firstName: firstName,
                                                        lastName: lastName,
                                                        email: email,
                                                        password: password,
                                                        contactNumber: contactNumber,
                                                        dateOfBirth: dateFormatterF.string(from: dob),
                                                        wwccn: wwccn,
                                                        subNewsletter: true)
            }
            .flatMapLatest {
                firstName,
                lastName,
                email,
                password,
                contactNumber,
                dateOfBirth,
                wwccn,
                subNewsletter in
                provider.registrationService.signup(
                    firstName: firstName,
                    lastName: lastName,
                    email: email,
                    password: password,
                    contactNumber: contactNumber,
                    dateOfBirth: dateOfBirth,
                    wwccn: wwccn,
                    subNewsletter: subNewsletter)
        }
    }
}
