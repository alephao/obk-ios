import UIKit

import ReactorKit
import RxSwiftExt
import RxCocoa

final class SplashViewController: BaseViewController, View {
    
    // MARK: UI
    fileprivate let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicatorView.startAnimating()
        self.view.addSubview(self.activityIndicatorView)
    }
    
    override func setupConstraints() {
        self.activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: Initializing
    init(reactor: SplashViewReactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuring
    func bind(reactor: SplashViewReactor) {
        // Action
        self.rx.viewDidAppear
            .map { _ in Reactor.Action.checkIfAuthenticated }
            .bindTo(reactor.action)
            .disposed(by: self.disposeBag)
        
        // State
        reactor.state.map { $0.isAuthenticated }
            .map { $0 ?? false }
            .subscribe(onNext: { [weak reactor] isAuthenticated in
                guard reactor != nil else { return }
                if !isAuthenticated {
                    AppDelegate.shared.presentLoginScreen()
                } else {
                    AppDelegate.shared.presentMainScreen()
                }
            })
            .disposed(by: self.disposeBag)
    }
    
}
