import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then
import UIKit

import ReactorKit

final class ProfileViewController: BaseViewController, View {
    
    // MARK: - Properties
    fileprivate let dataSource = RxTableViewSectionedReloadDataSource<ProfileSection>()
    
    // MARK: - UI
    fileprivate let tableView = UITableView(frame: .zero, style: .grouped).then {
        $0.rowHeight = 44
    }
    
    fileprivate let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: nil)
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Initializing
    init(reactor: ProfileViewReactor) {
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.title = "PROFILE_TITLE".localized()
        tabBarController?.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.navigationItem.rightBarButtonItem = nil
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    // MARK: - Configuring
    func bind(reactor: ProfileViewReactor) {
        dataSource.configureCell = { (dataSource, _, indexPath, _) in
            let section = dataSource[indexPath]
            
            switch section {
            case let .ProfileItemBasic(title):
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = title
                return cell
            case let .ProfileItemButton(title):
                let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
                cell.textLabel?.text = title
                return cell
            case let .ProfileItemSubtitle(title, subtitle):
                let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                cell.textLabel?.text = title
                cell.detailTextLabel?.text = subtitle
                return cell
            }
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            let section = dataSource[index]
            
            return section.header
        }
        
        // Action
        self.rx.viewDidLoad
            .flatMap { reactor.provider.userService.currentUser }
            .unwrap()
            .map { Reactor.Action.updateVolunteer($0) }
            .bindTo(reactor.action)
            .disposed(by: disposeBag)

        
        // State
        reactor.state.map { $0.sections }
            .bindTo(tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.isLoggedOut }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { _ in
                AppDelegate.shared.presentLoginScreen()
            })
            .disposed(by: self.disposeBag)
        
        // View
        tableView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { [weak self] sectionItem in
                guard let `self` = self, let reactor = self.reactor else { return }
                switch sectionItem {
                case .ProfileItemButton(_):
                    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    let logoutAction = UIAlertAction(title: "LOGOUT".localized(), style: .destructive) { _ in
                        reactor.action.onNext(.logout)
                    }
                    let cancelAction = UIAlertAction(title: "CANCEL".localized(), style: .cancel, handler: nil)
                    [logoutAction, cancelAction].forEach(actionSheet.addAction)
                    self.present(actionSheet, animated: true, completion: nil)
                    break
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }
}
