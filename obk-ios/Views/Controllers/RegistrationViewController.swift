import RxCocoa
import RxKeyboard
import RxSwift
import UIKit

final class RegistrationViewController: OldBaseViewController, UITextFieldDelegate {
    
    // MARK: NOT GOOD
    internal var currentActiveTextField: UITextField?
    internal var textFields = [UITextField]()
    
    // MARK: - UI Elements
    internal let toolbar = UIToolbar().then {
        $0.barStyle = .default
        $0.tintColor = Color.orange.uiColor()
    }
    
    internal let toolbarPreviousButton = UIBarButtonItem(title: "Previous", style: .plain, target: nil, action: nil)
    internal let toolbarHideButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: nil)
    internal let toolbarNextButton = UIBarButtonItem(title: "Next", style: .plain, target: nil, action: nil)
    
    internal let birthDatePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.maximumDate = Date()
    }
    
    internal let contactNumberTextField = UITextField().then {
        $0.keyboardType = .phonePad
        $0.placeholder = "REGISTRATION_CONTACTNUMBER_PLACEHOLDER".localized()
    }
    
    internal let contentView = UIView()
    
    internal let dateOfBirthTextField = UITextField().then {
        $0.placeholder = "REGISTRATION_DATEOFBIRTH_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let emailTextField = UITextField().then {
        $0.autocapitalizationType = .none
        $0.keyboardType = .emailAddress
        $0.placeholder = "REGISTRATION_EMAIL_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let firstNameTextField = UITextField().then {
        $0.placeholder = "REGISTRATION_FIRSTNAME_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let lastNameTextField = UITextField().then {
        $0.placeholder = "REGISTRATION_LASTNAME_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let passwordTextField = UITextField().then {
        $0.isSecureTextEntry = true
        $0.placeholder = "REGISTRATION_PASSWORD_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let registerButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("REGISTRATION_REGISTER_BUTTON".localized(), for: .normal)
        $0.setTitleColor(UIColor.orange, for: .normal)
    }
    
    internal let wwccnTextField = UITextField().then {
        $0.placeholder = "REGISTRATION_WWCN_PLACEHOLDER".localized()
        $0.returnKeyType = .next
    }
    
    internal let scrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.isScrollEnabled = true
    }
    
    // MARK: Overrided
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Initializing
    init(viewModel: RegistrationViewModelType) {
        super.init()
        self.configure(viewModel)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Life Cycle
    override func setupConstraints() {
        contactNumberTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(passwordTextField.snp.bottom).offset(16)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(view.snp.width)
            make.top.equalToSuperview()
        }
        
        dateOfBirthTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(contactNumberTextField.snp.bottom).offset(16)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(16)
            make.top.equalTo(firstNameTextField.snp.bottom).offset(8)
        }
        
        firstNameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.width.equalTo(firstNameTextField.snp.width)
            
            make.left.equalTo(firstNameTextField.snp.right).offset(8)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(emailTextField.snp.bottom).offset(8)
        }
        
        registerButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(wwccnTextField.snp.bottom).offset(16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        }
        
        wwccnTextField.snp.makeConstraints { make in
            make.height.equalTo(44)
            
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(dateOfBirthTextField.snp.bottom).offset(8)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        title = "REGISTRATION_TITLE".localized()
        
        view.backgroundColor = UIColor.hex(0xffffff)
        view.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: 396)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(emailTextField)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(contactNumberTextField)
        contentView.addSubview(dateOfBirthTextField)
        contentView.addSubview(wwccnTextField)
        contentView.addSubview(registerButton)
        
        let tgr = UITapGestureRecognizer()
        tgr.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        contentView.addGestureRecognizer(tgr)
        
        toolbar.setItems([toolbarPreviousButton,
                          toolbarNextButton,
                          UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                          toolbarHideButton], animated: false)
        toolbar.sizeToFit()
        
        emailTextField.inputAccessoryView = toolbar
        firstNameTextField.inputAccessoryView = toolbar
        lastNameTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        contactNumberTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputAccessoryView = toolbar
        dateOfBirthTextField.inputView = birthDatePicker
        wwccnTextField.inputAccessoryView = toolbar
        
        toolbarHideButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.snp.updateConstraints({ make in
                    make.bottom.equalToSuperview().offset(-keyboardVisibleHeight)
                })
            })
            .disposed(by: disposeBag)
        
        // MARK: NOT GOOD
        toolbarNextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.focusNextTextField()
            })
            .disposed(by: disposeBag)
        
        toolbarPreviousButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.focusPreviousTextField()
            })
            .disposed(by: disposeBag)
        
        textFields = [
            firstNameTextField,
            lastNameTextField,
            emailTextField,
            passwordTextField,
            contactNumberTextField,
            dateOfBirthTextField,
            wwccnTextField,
        ]
        
        for tf in textFields {
            tf.delegate = self
        }
    }
    
    // MARK: NOT GOOD
    internal func setActive(_ textField: UITextField) {
        self.currentActiveTextField = textField
    }
    
    internal func focusNextTextField() {
        guard let current = currentActiveTextField  else { return }
        guard var index = textFields.index(of: current) else { return }
        index += 1
        if index < textFields.count {
            let nextTextField = textFields[index]
            if nextTextField != wwccnTextField {
                nextTextField.becomeFirstResponder()
            } else if wwccnTextField.isHidden {
                view.endEditing(true)
            } else {
                nextTextField.becomeFirstResponder()
            }
        } else {
            view.endEditing(true)
        }
    }
    
    internal func focusPreviousTextField() {
        guard let current = currentActiveTextField  else { return }
        guard var index = textFields.index(of: current) else { return }
        index -= 1
        if index >= 0 {
            textFields[index].becomeFirstResponder()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        currentActiveTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if currentActiveTextField == textField {
            currentActiveTextField = nil
        }
    }
    
    // MARK: Configuring
    private func configure(_ viewModel: RegistrationViewModelType) {
        // MARK: ViewModel Inputs
        
        birthDatePicker.rx.value
            .bindTo(viewModel.dateOfBirthDidChange)
            .disposed(by: disposeBag)
        
        contactNumberTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.contactNumberTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        emailTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.emailTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        firstNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.firstNameTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        lastNameTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.lastNameTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.passwordTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        wwccnTextField.rx.controlEvent(.editingDidEndOnExit)
            .bindTo(viewModel.wwccnTextFieldDidReturn)
            .disposed(by: disposeBag)
        
        // MARK: ViewModel Outputs
        
        viewModel.dateOfBirth
            .drive(dateOfBirthTextField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.focusOnContactNumberTextField
            .subscribe(onNext: { [weak self] _ in
                self?.contactNumberTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnDateOfBirthTextField
            .subscribe(onNext: { [weak self] _ in
                self?.dateOfBirthTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnEmailTextField
            .subscribe(onNext: { [weak self] _ in
                self?.emailTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnFirstNameTextField
            .subscribe(onNext: { [weak self] _ in
                self?.firstNameTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnLastNameTextField
            .subscribe(onNext: { [weak self] _ in
                self?.lastNameTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnPasswordTextField
            .subscribe(onNext: { [weak self] _ in
                self?.passwordTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.focusOnWwccnTextField
            .subscribe(onNext: { [weak self] _ in
                self?.wwccnTextField.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        viewModel.wwccnIsHidden
            .bindTo(wwccnTextField.rx.isHidden)
            .disposed(by: disposeBag)
    }
}
