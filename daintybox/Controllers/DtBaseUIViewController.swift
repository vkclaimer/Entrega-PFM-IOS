//
//  DtBaseUIViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 04/28/22.
//

import Foundation
import UIKit

class DtBaseUIViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = " "
        self.navigationController?.navigationBar.topItem?.title = ""
        
        self.hideKeyboardWhenTappedAround()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func popBack(_ nb: Int) {
        if let viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            guard viewControllers.count < nb else {
                self.navigationController?.popToViewController(viewControllers[viewControllers.count - nb], animated: true)
                return
            }
        }
    }
    
    func popBack<T: UIViewController>(toControllerType: T.Type) {
        if var viewControllers: [UIViewController] = self.navigationController?.viewControllers {
            viewControllers = viewControllers.reversed()
            for currentViewController in viewControllers {
                if currentViewController .isKind(of: toControllerType) {
                    self.navigationController?.popToViewController(currentViewController, animated: true)
                    break
                }
            }
        }
    }
    
}
