import ReusableKit
import SnapKit
import UIKit

import ReactorKit
import RxSwift

import Then

final class GoingViewController: BaseViewController, View {
    
    // MARK: - Constants
    fileprivate struct Reusable {
        static let opportunityCell = ReusableCell<OpportunityCell>()
    }
    
    fileprivate struct Constant {
        static let shotTileSectionColumnCount = 2
    }
    
    // MARK: - UI
    fileprivate let emptyLabel = UILabel().then {
        $0.text = "No opportunities available"
        $0.textAlignment = .center
    }
    fileprivate let refreshControl = UIRefreshControl()
    fileprivate let tableView = UITableView(
        frame: .zero,
        style: .grouped
        ).then {
            $0.estimatedRowHeight = 200
            $0.register(Reusable.opportunityCell)
            $0.rowHeight = UITableViewAutomaticDimension
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Initializing
    init(reactor: GoingViewReactor) {
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
        
        view.backgroundColor = UIColor.hex(0xffffff)
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "OPPORTUNITIES_TITLE".localized()
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: GoingViewReactor) {
        
        // Action
        self.rx.viewDidLoad
            .map { Reactor.Action.refresh }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        self.refreshControl.rx.controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(Opportunity.self)
            .map(reactor.reactorForOpportunity)
            .subscribe(onNext: { [unowned self] reactor in
                let viewController = OpportunityDetailsViewController(reactor: reactor)
                self.navigationController?.pushViewController(viewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        // Output
        reactor.state.map { $0.isRefreshing }
            .distinctUntilChanged()
            .bindTo(refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.opportunities }
            .bindTo(tableView.rx.items) { tableView, row, opportunity in
                let viewModel = OpportunityCellViewModel(opportunity: opportunity)
                let cell = tableView.dequeue(Reusable.opportunityCell)!
                cell.configure(viewModel)
                return cell
            }
            .disposed(by: disposeBag)
        
    }
}

