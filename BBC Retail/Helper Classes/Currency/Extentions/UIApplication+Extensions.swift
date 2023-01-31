import UIKit

extension UIApplication {
    
    class func topViewControllerr(_ viewController: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(controller: nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(controller: presented)
        }
        
        return viewController
    }
}
