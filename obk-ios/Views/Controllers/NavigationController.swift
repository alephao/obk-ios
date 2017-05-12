import UIKit

class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.barStyle = .black
        navigationBar.tintColor = UIColor.white
        navigationBar.barTintColor = Color.orange.uiColor()
        navigationBar.backgroundColor = Color.orange.uiColor()
    }
}
