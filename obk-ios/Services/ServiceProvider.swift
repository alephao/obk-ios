import Moya

protocol ServiceProviderType: class {
    var networking: Networking<OBKAPI> { get }
    var authService: AuthServiceType { get }
    var alertService: AlertServiceType { get }
    var opportunitiesService: OpportunitiesServiceType { get }
    var registrationService: RegistrationServiceType { get }
    var userService: UserServiceType { get }
}

final class ServiceProvider: ServiceProviderType {
    lazy var networking: Networking<OBKAPI> = .init(plugins: [AuthPlugin(provider: self)])
    lazy var alertService: AlertServiceType = AlertService(provider: self)
    lazy var authService: AuthServiceType = AuthService(provider: self)
    lazy var opportunitiesService: OpportunitiesServiceType = OpportunitiesService(provider: self)
    lazy var registrationService: RegistrationServiceType = RegistrationService(provider: self)
    lazy var userService: UserServiceType = UserService(provider: self)
}
