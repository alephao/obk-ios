import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UITableView {
    
    func itemSelected<S: SectionModelType>(
        dataSource: TableViewSectionedDataSource<S>
        ) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
    
}
