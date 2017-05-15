import ReactorKit
import RxCocoa
import RxSwift
import RxSwiftUtilities

enum RegistrationViewAlertAction: AlertActionType {
    case ok
    
    var title: String? {
        switch self {
        case .ok: return "Ok"
        }
    }
    
    var style: UIAlertActionStyle {
        switch self {
        case .ok: return .default
        }
    }
}

final class RegistrationViewReactor: Reactor {
    
    enum Action {
        case signup
        case updateContactNumber(String)
        case updateDateOfBirth(Date)
        case updateEmail(String)
        case updateFirstName(String)
        case updateLastName(String)
        case updatePassword(String)
        case updateWWCCN(String)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoggedIn(Bool)
        case updateContactNumber(String)
        case updateDateOfBirth(Date)
        case updateEmail(String)
        case updateFirstName(String)
        case updateLastName(String)
        case updatePassword(String)
        case updateWWCCN(String)
    }
    
    struct State {
        var contactNumber: String = ""
        var dateOfBirth: Date = Date()
        var email: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var password: String = ""
        var wwccn: String = ""
        
        var isFormValid: Bool = false
        var isLoading: Bool = false
        var isLoggedIn: Bool = false
        var isWWCCNHidden: Bool = true
        
        init() { }
    }
    
    let provider: ServiceProviderType
    let initialState: State = State()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .signup:
            guard self.currentState.isFormValid else { return .empty() }
            let dateFormatter = DateFormatter(dateFormat: "yyyy-MM-dd")
            let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
            let setNotLoading: Observable<Mutation> = .just(Mutation.setLoading(false))
            let setLoggedIn: Observable<Mutation> = self.provider.authService
                .signup(firstName: self.currentState.firstName,
                        lastName: self.currentState.lastName,
                        email: self.currentState.email,
                        password: self.currentState.password,
                        contactNumber: self.currentState.contactNumber,
                        dateOfBirth: dateFormatter.string(from: self.currentState.dateOfBirth),
                        wwccn: self.currentState.wwccn,
                        subNewsletter: true) // TODO: SubNewsletter
                .catchErrorJustReturn(nil)
                .map { volunteer in volunteer != nil }
                .flatMapLatest { success -> Observable<Bool> in
                    if success {
                        return Observable.just(success)
                    } else {
                        return self.provider.alertService
                            .show(title: "Error",
                                  message: "Registration failed",
                                  preferredStyle: .alert,
                                  actions: [RegistrationViewAlertAction.ok])
                            .map { _ in success }
                    }
                }
                .map(Mutation.setLoggedIn)
            
            return Observable.concat([setLoading, setLoggedIn, setNotLoading])
        case let .updateContactNumber(contact):
            return .just(.updateContactNumber(contact))
        case let .updateDateOfBirth(dob):
            return .just(.updateDateOfBirth(dob))
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case let .updateFirstName(firstName):
            return .just(.updateFirstName(firstName))
        case let .updateLastName(lastName):
            return .just(.updateLastName(lastName))
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        case let .updateWWCCN(wwccn):
            return .just(.updateWWCCN(wwccn))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(loading):
            state.isLoading = loading
            return state
        case let .setLoggedIn(loggedIn):
            state.isLoggedIn = loggedIn
            return state
        case let .updateContactNumber(contact):
            state.contactNumber = contact
            state.isFormValid = formValid(state: state)
            return state
        case let .updateDateOfBirth(dob):
            state.dateOfBirth = dob
            state.isWWCCNHidden = over18(date: dob)
            state.isFormValid = formValid(state: state)
            return state
        case let .updateEmail(email):
            state.email = email
            state.isFormValid = formValid(state: state)
            return state
        case let .updateFirstName(firstName):
            state.firstName = firstName
            state.isFormValid = formValid(state: state)
            return state
        case let .updateLastName(lastName):
            state.lastName = lastName
            state.isFormValid = formValid(state: state)
            return state
        case let .updatePassword(password):
            state.password = password
            state.isFormValid = formValid(state: state)
            return state
        case let .updateWWCCN(wwccn):
            state.wwccn = wwccn
            state.isFormValid = formValid(state: state)
            return state
        }
    }
    
    fileprivate func formValid(state: State) -> Bool {
        return !state.contactNumber.isEmpty &&
        isValidEmail(state.email) &&
        !state.firstName.isEmpty &&
        !state.lastName.isEmpty &&
        (state.password.characters.count >= 8) &&
        (state.isWWCCNHidden || (!state.isWWCCNHidden && !state.wwccn.isEmpty))
    }
    
    fileprivate func over18(date: Date) -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        guard let eighteenYearsAgo = calendar.date(byAdding: .year, value: -18, to: today) else {
            return false
        }
        return date > eighteenYearsAgo
    }
    
}
