//
//  Utils.swift
//  daintybox
//
//  Created by Julio Rodriguez on 04/28/22.
//

import Foundation
import UIKit

class Utils{
    
    static var loadingAlert: UIAlertController? = nil

    static func showLoading(parent: UIViewController,title: String) -> Void{
        self.loadingAlert = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        
        self.loadingAlert?.view.addSubview(loadingIndicator)
        parent.present(self.loadingAlert!, animated: true, completion: nil)
    }

    static func hideLoading(finish: (() -> Swift.Void)? = {} ){
        if let alert = self.loadingAlert {
            alert.dismiss(animated: true, completion: {
                self.loadingAlert = nil
                finish?()
            })
        }else{
            finish?()
        }
    }


    static func showAcceptMessage(message: String,title: String? = "" ) -> Void{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
        }))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        // Busco la vista al tope del stack
        if let topController = UIApplication.topViewController() {
            rootViewController = topController
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }

    static func showAcceptMessage(message: String,title: String? = "",callback: @escaping () -> Void ) -> Void{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: true, completion: nil)
            callback()
        }))
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        
        // Busco la vista al tope del stack
        if let topController = UIApplication.topViewController() {
            rootViewController = topController
        }
        
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        
        rootViewController?.present(alertController, animated: true, completion: nil)
    }

    static func showAcceptMessage(vcontroller: UIViewController ,message: String,title: String? = "",callback: @escaping () -> Void ) -> Void{
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            alertController.dismiss(animated: false, completion: nil)
            callback()
        }))
        
        vcontroller.present(alertController, animated: true, completion: nil)
    }
    
    static func showToast(context: UIViewController, message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: context.view.frame.size.width/2 - 125, y: context.view.frame.size.height-100, width: 250, height: 35))
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        context.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 9.0, delay: 0.1, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }
    
    static func showToast(context: UIViewController, message : String,pos_y_offset: Int) {
        
        let toastLabel = UILabel(frame: CGRect(x: context.view.frame.size.width/2 - 125, y: context.view.frame.size.height-CGFloat(pos_y_offset), width: 250, height: 35))
        
        toastLabel.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        
        context.view.addSubview(toastLabel)
        
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveLinear, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
        
    }


}
