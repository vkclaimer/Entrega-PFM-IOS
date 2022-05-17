//
//  HomeViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/05/22.
//
import UIKit

class HomeViewController: UITabBarController{
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "Dainty Box"
        self.navigationController?.hideTransparentNavigationBar()
    }
}
