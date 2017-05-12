import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    fileprivate let serviceProvider: ServiceProviderType = ServiceProvider()
    
    
    // MARK: UI
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
        ) -> Bool {
        
        let splashViewReactor = SplashViewReactor(provider: serviceProvider)
        let splashViewController = SplashViewController(reactor: splashViewReactor)
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        
        window.rootViewController = splashViewController
        self.window = window
        
        return true
    }
    
    // MARK: Presenting
    
    func presentLoginScreen() {
        let loginViewReactor = LoginViewReactor(provider: serviceProvider)
        let viewController = LoginViewController(reactor: loginViewReactor)
        let nav = NavigationController(rootViewController: viewController)
        self.window?.rootViewController = nav
    }
    
    func presentMainScreen() {
        let rootTabBarViewReactor = RootTabBarViewReactor(provider: serviceProvider)
        let rootTabBarController = RootTabBarViewController(reactor: rootTabBarViewReactor)
        let nav = NavigationController(rootViewController: rootTabBarController)
        self.window?.rootViewController = nav
    }
    
    func presentAlert(_ alert: UIAlertController) {
        let presentingViewController = self.window?.rootViewController?.presentingViewController ?? self.window?.rootViewController
        presentingViewController?.present(alert, animated: true, completion: nil)
    }

}
