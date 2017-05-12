import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
