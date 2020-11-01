//
//  UIViewController+Alert.swift
//  AVFoundation+SaveLocal
//
//  Created by Glenn Posadas on 11/1/20.
//

import UIKit

var windowRootController: UIViewController? {
    if #available(iOS 13.0, *) {
        let windowScene = UIApplication.shared
            .connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first
        
        if let window = windowScene as? UIWindowScene {
            return window.windows.last?.rootViewController
        }
        
        return UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
    } else {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}

/// Category for any controller.
extension UIViewController {
    /// The completion callback for the ```alert```.
    typealias AlertCallBack = ((_ userDidTapFirstButton: Bool) -> Void)
    
    /// Class function to get the current or top most screen.
    class func current(controller: UIViewController? = windowRootController) -> UIViewController? {
        guard let controller = controller else { return nil }
        
        if let navigationController = controller as? UINavigationController {
            return current(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return current(controller: selected)
            }
        }
        if let presented = controller.presentedViewController {
            return current(controller: presented)
        }
        return controller
    }
    
    /**
     Presents an alertController with completion.
     
     - Author: Glenn
     
     - parameter title: The title of the alert.
     - parameter message: The body of the alert, nullable, since we can just sometimes use the title parameter.
     - parameter okButtonTitle: the title of the okay button.
     - parameter cancelButtonTitle: The title of the cancel button, defaults to nil, nullable.
     - parameter cancelButtonIsDestructive: tells if the CANCEL button should be destructive or not. Defaults to false
     - parameter completion: The ```AlertCallBack```, returns Bool. True when the user taps on the OK button, otherwise false.
     */
    func alert(
        title: String,
        message: String? = nil,
        okButtonTitle: String,
        cancelButtonTitle: String? = nil,
        cancelButtonIsDestructive: Bool = false,
        withBlock completion: AlertCallBack?) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let cancelButtonTitle = cancelButtonTitle {
            let cancelActionStyle: UIAlertAction.Style = cancelButtonIsDestructive ? .destructive : .default
            let cancelAction = UIAlertAction(title: cancelButtonTitle, style: cancelActionStyle) { _ in
                completion?(false)
            }
            alertController.addAction(cancelAction)
        }
        
        let okAction = UIAlertAction(title: okButtonTitle, style: .default ) { _ in
            completion?(true)
        }
        alertController.addAction(okAction)
        
        alertController.view.tintColor = .black
        present(alertController, animated: true, completion: nil)
    }
    
    /// Minimied version of alert function.
    func alert(_ title: String) {
        self.alert(title: title, okButtonTitle: "Ok", withBlock: nil)
    }
}



