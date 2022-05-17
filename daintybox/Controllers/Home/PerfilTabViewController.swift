//
//  PerfilTabViewController.swift
//  daintybox
//
//  Created by Julio Rodriguez on 05/07/22.
//
import UIKit
import FirebaseAuth

class PerfilTabViewController: UIViewController{
    
    @IBOutlet var iwUser: UIImageView!
    @IBOutlet var lblUsuario: UILabel!
    @IBOutlet var lblEmail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iwUser.layer.cornerRadius = iwUser.frame.height / 2
        iwUser.clipsToBounds = true
        
        let user = Auth.auth().currentUser
        if user != nil {
            
            lblUsuario.text = user?.displayName
            lblEmail.text = user?.email
            
        }        
        
    }
    
    
    
    @IBAction func pressedCerrarSesion(_ sender: Any) {
        try? Auth.auth().signOut()
        
        let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
        
        sceneDelegate.handleLogin(withWindow: sceneDelegate.window!)
    }
}
