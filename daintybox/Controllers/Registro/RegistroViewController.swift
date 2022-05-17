//
//  RegistroViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/05/22.
//

import UIKit
import FirebaseAuth

class RegistroViewController: UIViewController{
    
    @IBOutlet var textFieldEmail: UITextField!
    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var textFieldUsuario: UITextField!
    @IBOutlet var lblInicia: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let gestureInicia = UITapGestureRecognizer(target: self, action: #selector (self.tapIniciaSesion(_:)))
        lblInicia.addGestureRecognizer(gestureInicia)
    }
    
    @IBAction func pressedRegistrarme(_ sender: Any) {
        let email = self.textFieldEmail.text ?? ""
        let pass = self.textFieldPassword.text ?? ""
        let usuario = self.textFieldUsuario.text ?? ""
        
        if(!email.isEmpty && !pass.isEmpty && !usuario.isEmpty){
            
            Utils.showLoading(parent: self, title: "Creando usuario..")
            
            Auth.auth().createUser(withEmail: email, password: pass) { authResult, error in
              
                
                Utils.hideLoading()
                
                if(error != nil){
                    Utils.showAcceptMessage(message: error!.localizedDescription)
                }else{
                    
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = usuario
                    changeRequest?.commitChanges { error in
                      
                    }
                    
                    let sceneDelegate = UIApplication.shared.connectedScenes
                            .first!.delegate as! SceneDelegate
                    
                    sceneDelegate.handleLogin(withWindow: sceneDelegate.window!)
                }
                
            }
            
        }else{
            Utils.showAcceptMessage(message: "Debes llenar todos los campos")
        }
        
    }
    
    @objc func tapIniciaSesion(_ sender: UITapGestureRecognizer)  {
        
        let storyboard = UIStoryboard(name: "IniciarSesion", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "IniciarSesionController") as! IniciarSesionController
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
}
