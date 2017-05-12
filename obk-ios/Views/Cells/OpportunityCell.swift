import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class OpportunityCell: BaseTableViewCell {

    internal let disposeBag = DisposeBag()

    // MARK: Properties

	internal let dateLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: 0.1)
        $0.textColor = UIColor.hex(0x78D11F)
	}

	internal let descriptionLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: 0.1)
        $0.numberOfLines = 10
        $0.textColor = UIColor.hex(0x666666)
	}

	internal let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: 0.5)
        $0.numberOfLines = 2
        $0.textColor = UIColor.hex(0x333333)
	}

    // MARK: Initializing
    override func initialize() {
		addSubview(dateLabel)
		addSubview(descriptionLabel)
		addSubview(titleLabel)

		dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalToSuperview().offset(16)
		}

		descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
		}

		titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
		}
    }

    // MARK: Configuring
    func configure(_ viewModel: OpportunityCellViewModelType) {
        
        // MARK: ViewModel Outputs

		viewModel.date
			.drive(dateLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.description
			.drive(descriptionLabel.rx.text)
			.disposed(by: disposeBag)

		viewModel.title
			.drive(titleLabel.rx.text)
			.disposed(by: disposeBag)
    }
}
