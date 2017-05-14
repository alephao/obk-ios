import UIKit.UIAlertController
import RxSwift

final class MockAlertService: AlertServiceType {
    
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertControllerStyle,
        actions: [Action]
        ) -> Observable<Action> {
        return .just(actions[0])
    }
    
}
