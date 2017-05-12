import RxCocoa
import RxSwift

import SnapKit
import UIKit

import ReactorKit

import Then

final class OpportunityDetailsViewController: BaseViewController, View {
    
    // MARK: - UI Elements
    fileprivate let contentView = UIView()

    fileprivate let dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: 0.1)
        $0.textColor = UIColor.hex(0x78D11F)
    }
    
    fileprivate let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 22, weight: 0.1)
        $0.numberOfLines = 100
        $0.textColor = UIColor.hex(0x666666)
    }
    
    fileprivate let joiningSpinner = UIActivityIndicatorView(activityIndicatorStyle: .gray).then {
        $0.hidesWhenStopped = true
    }
    
    fileprivate let actionButton = UIButton(type: .system).then {
        $0.backgroundColor = Color.orange.uiColor()
        $0.setTitle("OPPORTUNITY_DETAILS_JOIN_BUTTON".localized(), for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
    }
    
    fileprivate let scrollView = UIScrollView().then {
        $0.isUserInteractionEnabled = true
        $0.isScrollEnabled = true
    }
    
    fileprivate let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 32, weight: 0.5)
        $0.numberOfLines = 5
        $0.textColor = UIColor.hex(0x333333)
    }
    
    // MARK: Overrided
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Initializing
    init(reactor: OpportunityDetailsViewReactor) {
        defer { self.reactor = reactor }
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        contentView.backgroundColor = .yellow
        
        title = "OPPORTUNITY_DETAILS_TITLE".localized()
        
        view.backgroundColor = UIColor.hex(0xffffff)
        view.addSubview(scrollView)
        view.addSubview(actionButton)
        view.addSubview(joiningSpinner)
        
        scrollView.addSubview(contentView)
        
		contentView.addSubview(dateLabel)
		contentView.addSubview(descriptionLabel)
		contentView.addSubview(titleLabel)
    }
    
    override func setupConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            
            make.top.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
        }
        
        scrollView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().offset(64)
        }
        
        joiningSpinner.snp.makeConstraints { make in
            make.center.equalTo(actionButton.snp.center)
        }
        
        actionButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(scrollView.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: OpportunityDetailsViewReactor) {
        
        // Action
        
        actionButton.rx.tap
            .withLatestFrom(reactor.state.map { state in state.opportunity.going })
            .map { going in
                if going {
                    return Reactor.Action.resign
                } else {
                    return Reactor.Action.join
                }
            }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        // State
        
        reactor.state.map { $0.opportunity }
            .subscribe(onNext: { [unowned self] opportunity in
                self.dateLabel.text = opportunity.durationString()
                self.titleLabel.text = opportunity.title
                self.descriptionLabel.text = opportunity.desc
                
                print("Going: \(opportunity.going)")
                opportunity.going ? self.setupLeaveButton(self.actionButton) : self.setupJoinButton(self.actionButton)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .observeOn(MainScheduler.instance)
            .bindTo(joiningSpinner.rx.isAnimating)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoading }
            .observeOn(MainScheduler.instance)
            .bindTo(actionButton.rx.isHidden)
            .disposed(by: disposeBag)

    }
    
    fileprivate func setupJoinButton(_ button: UIButton) {
        button.backgroundColor = Color.green.uiColor()
        button.setTitle("OPPORTUNITY_DETAILS_JOIN_BUTTON".localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
    }
    
    fileprivate func setupLeaveButton(_ button: UIButton) {
        button.backgroundColor = Color.red.uiColor()
        button.setTitle("OPPORTUNITY_DETAILS_LEAVE_BUTTON".localized(), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        
    }
}

