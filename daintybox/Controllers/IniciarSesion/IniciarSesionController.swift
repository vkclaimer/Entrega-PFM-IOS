//
//  IniciarSesionController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/04/22.
//

import UIKit
import Firebase

class IniciarSesionController: UIViewController{
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var lblRegistrate: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gestureRegistrate = UITapGestureRecognizer(target: self, action: #selector (self.tapRegistrate(_:)))
        lblRegistrate.addGestureRecognizer(gestureRegistrate)
    }
    
    @IBAction func pressedIniciarSesion(_ sender: Any) {
        let email = self.textFieldEmail.text ?? ""
        let pass = self.textFieldPassword.text ?? ""
        
        
        
        Utils.showLoading(parent: self, title: "Iniciando sesión..")
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] authResult, error in
            
            guard self != nil else { return }
            
            Utils.hideLoading()
            
            if(error != nil){
                Utils.showAcceptMessage(message: error!.localizedDescription)
            }else{
                let sceneDelegate = UIApplication.shared.connectedScenes
                        .first!.delegate as! SceneDelegate
                
                sceneDelegate.handleLogin(withWindow: sceneDelegate.window!)
            }
            
        }
        
        
    }
    
    
    
    @objc func tapRegistrate(_ sender: UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "Registro", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "RegistroViewController") as! RegistroViewController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
}
