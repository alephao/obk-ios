import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

import ReactorKit

final class LoginViewController: BaseViewController, View {
    
    // MARK: - UI
    fileprivate let emailTextField = UITextField().then {
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.keyboardType = .emailAddress
        $0.placeholder = "LOGIN_EMAIL_PLACEHOLDER".localized()
    }
    
    fileprivate let fieldsSeparator = UIView().then {
        $0.backgroundColor = .hex(0xCCCCCC)
    }
    
    fileprivate let loginButton = UIButton(type: UIButtonType.custom).then {
        $0.backgroundColor = .hex(0x007aff)
        $0.setTitle("LOGIN_SIGNIN_BUTTON".localized(), for: .normal)
    }
    
    fileprivate let loginSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    fileprivate let passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "LOGIN_PASSWORD_PLACEHOLDER".localized()
    }
    
    fileprivate let signupButton = UIButton(type: UIButtonType.custom).then {
        $0.backgroundColor = Color.orange.uiColor()
        $0.setTitle("LOGIN_SIGNUP_BUTTON".localized(), for: .normal)
        $0.setTitleColor(UIColor.hex(0xffffff), for: .normal)
    }
    
    fileprivate let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: 500)
        $0.numberOfLines = 2
        $0.textColor = .black
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Initializing
    init(reactor: LoginViewReactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func setupConstraints() {
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalTo(view.snp.leftMargin).offset(16)
            make.right.equalTo(view.snp.rightMargin).offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
        }
        
        fieldsSeparator.snp.makeConstraints { make in
            make.height.equalTo(1)
            
            make.left.equalTo(emailTextField.snp.left)
            make.right.equalTo(emailTextField.snp.right)
            make.top.equalTo(emailTextField.snp.bottom)
        }
        
        loginButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalTo(view.snp.leftMargin).offset(16)
            make.right.equalTo(view.snp.rightMargin).offset(-16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(32)
        }
        
        loginSpinner.snp.makeConstraints { make in
            make.center.equalTo(loginButton.snp.center)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalTo(view.snp.leftMargin).offset(16)
            make.right.equalTo(view.snp.rightMargin).offset(-16)
            make.top.equalTo(fieldsSeparator.snp.bottom)
        }
        
        signupButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalTo(view.snp.leftMargin).offset(16)
            make.right.equalTo(view.snp.rightMargin).offset(-16)
            make.top.equalTo(loginButton.snp.bottom).offset(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.leftMargin).offset(16)
            make.right.equalTo(view.snp.rightMargin).offset(-16)
            make.top.equalToSuperview().offset(96) // 64 Navbar + 32 spacing
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.hex(0xffffff)
        
        view.addSubview(emailTextField)
        view.addSubview(fieldsSeparator)
        view.addSubview(loginButton)
        view.addSubview(loginSpinner)
        view.addSubview(passwordTextField)
        view.addSubview(signupButton)
        view.addSubview(titleLabel)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "LOGIN_TITLE".localized()
        title = "LOGIN_TITLE".localized()
    }
    
    // MARK: - Configuring
    func bind(reactor: LoginViewReactor) {
        
        // Action
        Observable.of(loginButton.rx.tap, passwordTextField.rx.controlEvent(.editingDidEndOnExit))
            .merge()
            .map { Reactor.Action.login }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.text.changed
            .unwrap()
            .map { email in Reactor.Action.updateEmail(email) }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [unowned self] _ in
                self.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text.changed
            .unwrap()
            .map { password in Reactor.Action.updatePassword(password) }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        signupButton.rx.tap
            .map { reactor.registrationViewModel() }
            .subscribe(onNext: { [weak self] viewModel in
                let controller = RegistrationViewController(viewModel: viewModel)
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.isCredentialsValid }
            .observeOn(MainScheduler.instance)
            .bindTo(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .observeOn(MainScheduler.instance)
            .bindTo(loginButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .observeOn(MainScheduler.instance)
            .bindTo(loginSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoggedIn }
            .distinctUntilChanged()
            .observeOn(MainScheduler.instance)
            .filter { $0 }
            .subscribe(onNext: { _ in
                AppDelegate.shared.presentMainScreen()
            })
            .disposed(by: disposeBag)
    }
}

