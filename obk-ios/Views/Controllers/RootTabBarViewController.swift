import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class RootTabBarViewController: UITabBarController, View {
    
    // MARK: Properties
    var disposeBag = DisposeBag()
    
    
    // MARK: Initializing
    init(reactor: RootTabBarViewReactor) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuring
    func bind(reactor: RootTabBarViewReactor) {
        let opportunitiesController = reactor.state.map { $0.opportunitiesViewReactor }
            .map { reactor -> UIViewController in
                let opportunitiesViewController = OpportunitiesViewController(reactor: reactor)
                let opportunitiesTabBarItem = UITabBarItem(title: "Opportunities",
                                                           image: UIImage(named: "ic_search")!,
                                                           tag: 0)
                opportunitiesViewController.tabBarItem = opportunitiesTabBarItem
                return opportunitiesViewController
        }
        
        let goingController = reactor.state.map { $0.goingViewReactor }
            .map { reactor -> UIViewController in
                let goingViewController = GoingViewController(reactor: reactor)
                let goingTabBarItem = UITabBarItem(title: "Going",
                                                   image: UIImage(named:
                                                    "ic_done")!, tag: 1)
                goingViewController.tabBarItem = goingTabBarItem
                return goingViewController
        }
        
        let profileController = reactor.state.map { $0.profileViewReactor }
            .map { reactor -> UIViewController in
                let profileViewController = ProfileViewController(reactor: reactor)
                let profileTabBarItem = UITabBarItem(title: "Profile",
                                                     image: UIImage(named: "ic_person")!,
                                                     tag: 2)
                profileViewController.tabBarItem = profileTabBarItem
                return profileViewController
        }
        
        let controllers: [Observable<UIViewController>] = [
            opportunitiesController,
            goingController,
            profileController
            ]
        Observable.combineLatest(controllers) { $0 }
            .subscribe(onNext: { [weak self] navigationControllers in
                self?.viewControllers = navigationControllers
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - View Life Cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = Color.orange.uiColor()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
