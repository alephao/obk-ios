import RxCocoa
import RxSwift
import UIKit.UIImage

protocol OpportunityCellViewModelType: class {
    
    // MARK: Outputs
	var date: Driver<String> { get }
	var description: Driver<String> { get }
	var title: Driver<String> { get }
}

final class OpportunityCellViewModel: OpportunityCellViewModelType {

    // MARK: Outputs
	let date: Driver<String>
	let description: Driver<String>
	let title: Driver<String>

    init(opportunity: Opportunity) {
        let dateFormatter = DateFormatter(dateFormat: "ha")
        var dateString = ""
        
        if let startDate = opportunity.startDateDate(),
            let endDate = opportunity.endDateDate() {
            dateString = "\(dateFormatter.string(from: startDate)) ~ \(dateFormatter.string(from: endDate))"
        } else {
            dateString = "Failed to get date"
        }
        
		self.date = Observable.just(dateString)
            .asDriver(onErrorJustReturn: dateString)
		
        self.description = Observable.just(opportunity.desc)
            .asDriver(onErrorJustReturn: opportunity.desc)
        
		self.title = Observable.just(opportunity.title)
            .asDriver(onErrorJustReturn: opportunity.title)
    }

}
