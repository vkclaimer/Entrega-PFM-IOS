//
//  ViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 04/26/22.
//

import UIKit

class SplashLoginController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressedRegistrarme(_ sender: Any) {
        
        // Pantalla a llamar
        let storyboard = UIStoryboard(name: "Registro", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegistroViewController") as! RegistroViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func pressedIniciarSesion(_ sender: Any) {
        
        // Pantalla a llamar
        let storyboard = UIStoryboard(name: "IniciarSesion", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IniciarSesionController") as! IniciarSesionController
        
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

