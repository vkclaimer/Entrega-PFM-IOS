//
//  SceneDelegate.swift
//  daintybox
//
//  Created by Julio Rodriguez on 04/26/22.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        handleLogin(withWindow: window)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func handleLogin(withWindow window: UIWindow?) {
        //try? Auth.auth().signOut()
        
        
        if Auth.auth().currentUser != nil {
            self.showMainApp(withWindow: window)
        } else {
            self.showLogin(withWindow: window)
        }
    }
    
    func showLogin(withWindow window: UIWindow?) {
        window?.subviews.forEach { $0.removeFromSuperview() }
        window?.rootViewController = nil
        
        let splashNavController = UIStoryboard(name: "SplashLogin", bundle: nil).instantiateViewController(withIdentifier: "NavigationControllerDT") as! UINavigationController
        
        let splashController = splashNavController.viewControllers.first as! SplashLoginController
        
        
        window?.rootViewController = splashNavController
        window?.makeKeyAndVisible()
    }
    
    func showMainApp(withWindow window: UIWindow?) {
        window?.rootViewController = nil
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let homeController = storyboard.instantiateViewController(withIdentifier: "NavigationControllerDT")
        
        window?.rootViewController = homeController
        window?.makeKeyAndVisible()
    }

}

extension UIScene {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}



