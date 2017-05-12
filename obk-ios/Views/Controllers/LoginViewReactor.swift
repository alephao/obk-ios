import ReactorKit
import RxCocoa
import RxSwift
import RxSwiftUtilities

enum LoginViewAlertAction: AlertActionType {
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

final class LoginViewReactor: Reactor {
    
    enum Action {
        case login
        case updateEmail(String)
        case updatePassword(String)
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setLoggedIn(Bool)
        case updateEmail(String)
        case updatePassword(String)
    }
    
    struct State {
        var email: String
        var password: String
        var isCredentialsValid: Bool = false
        var isLoading: Bool = false
        var isLoggedIn: Bool = false
        
        init() {
            self.email = ""
            self.password = ""
        }
    }
    
    let provider: ServiceProviderType
    let initialState: State = State()
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .login:
            guard self.currentState.isCredentialsValid else { return .empty() }
            let setLoading: Observable<Mutation> = .just(Mutation.setLoading(true))
            let setNotLoading: Observable<Mutation> = .just(Mutation.setLoading(false))
            let setLoggedIn: Observable<Mutation> =  self.provider.authService
                .signIn(email: self.currentState.email, password: self.currentState.password)
                .catchErrorJustReturn(nil)
                .do(onNext: { [weak self] volunteer in
                    self?.provider.userService.updateCurrentUser(volunteer)
                })
                .map { volunteer in volunteer != nil }
                .flatMapLatest { success -> Observable<Bool> in
                    if success {
                        return Observable.just(success)
                    } else {
                        return self.provider.alertService
                            .show(title: "Erorr",
                                  message: "Failed to authenticate",
                                  preferredStyle: .alert,
                                  actions: [LoginViewAlertAction.ok])
                            .map { _ in success }
                    }
                }
                .debug()
                .map(Mutation.setLoggedIn)

            return setLoading.concat(setLoggedIn).concat(setNotLoading)
        case let .updateEmail(email):
            return .just(.updateEmail(email))
        case let .updatePassword(password):
            return .just(.updatePassword(password))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
            
        case let .setLoggedIn(isLoggedIn):
            state.isLoggedIn = isLoggedIn
            return state
            
        case let .updateEmail(email):
            state.email = email
            state.isCredentialsValid = isValidEmail(email) && !state.password.isEmpty
            return state
            
        case let .updatePassword(password):
            state.password = password
            state.isCredentialsValid = isValidEmail(state.email) && !password.isEmpty
            return state
        }
    }
    
    func registrationViewModel() -> RegistrationViewModelType {
        return RegistrationViewModel(provider: provider)
    }
    
}
