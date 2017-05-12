import UIKit

import RxSwift

protocol AlertActionType {
    var title: String? { get }
    var style: UIAlertActionStyle { get }
}

extension AlertActionType {
    var style: UIAlertActionStyle {
        return .default
    }
}

protocol AlertServiceType: class {
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertControllerStyle,
        actions: [Action]
        ) -> Observable<Action>
}

final class AlertService: BaseService, AlertServiceType {
    
    func show<Action: AlertActionType>(
        title: String?,
        message: String?,
        preferredStyle: UIAlertControllerStyle,
        actions: [Action]
        ) -> Observable<Action> {
        return Observable.create { observer in
            let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
            for action in actions {
                let alertAction = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alert.addAction(alertAction)
            }
            AppDelegate.shared.presentAlert(alert)
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
