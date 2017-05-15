import Foundation

final class MockServiceProvider: ServiceProviderType {
    lazy var networking: Networking<OBKAPI> = .init(plugins: [AuthPlugin(provider: self)])
    lazy var alertService: AlertServiceType = MockAlertService()
    lazy var authService: AuthServiceType = MockAuthService()
    lazy var opportunitiesService: OpportunitiesServiceType = MockOpportunitiesService()
//    lazy var registrationService: RegistrationServiceType = MockRegistrationService()
    lazy var userService: UserServiceType = MockUserService()
}
