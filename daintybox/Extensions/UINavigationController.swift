//
//  UINavigationController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/10/22.
//

import Foundation
import UIKit

extension UINavigationController {
    
    public func presentTransparentNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.backgroundColor = UIColor.black
        navigationBarAppearance.shadowColor = .clear
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    public func setAlphaNavigationBar(alpha : CGFloat){
        /** IMAGEN DEL NAV **/
        var alpha_nav = alpha
        
        if(alpha_nav >= 1.0){
            alpha_nav = 0.995833333333333
        }
        
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.backgroundColor = UIColor.greenBar.withAlphaComponent(alpha_nav)
        navigationBarAppearance.shadowColor = .clear
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
    public func hideTransparentNavigationBar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationBarAppearance.backgroundColor = UIColor.greenBar.withAlphaComponent(1.0)
        navigationBarAppearance.shadowColor = .clear
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
    }
    
}
