//
//  SceneDelegate.swift
//  MyMapKit
//
//  Created by Vũ Quý Đạt  on 10/12/2020.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        guard let _ = (scene as? UIWindowScene) else { return }
        guard let windowScene = (scene as? UIWindowScene) else { return }
        if Auth().token == nil {
        
        //self.window =  UIWindow(frame: UIScreen.main.bounds)
        
        // method 1
            self.window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let rootVC = storyboard.instantiateViewController(identifier: "LoginNavigation")
//            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
        }
        // App auto jump into Main.storyboard

        // for mess app
        
        // method 2
//        let windowScene = UIWindowScene(session: session, connectionOptions: connectionOptions)
//        self.window = UIWindow(windowScene: windowScene)
//        //self.window =  UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "MyStoryboardName", bundle: nil)
//        guard let rootVC = storyboard?.instantiateViewController(identifier: "ViewControllerIdentifierName") as? ViewController else {
//            print("ViewController not found")
//            return
//        }
//        let rootNC = UINavigationController(rootViewController: rootVC)
//        self.window?.rootViewController = rootNC
//        self.window?.makeKeyAndVisible()
        
        
        
//        let applicationFrame = UIScreen.main.applicationFrame
//        let window = UIWindow(frame: applicationFrame)
//
//        if Auth().token == nil {
//            let rootController = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginNavigation")
//            self.window?.rootViewController = rootController
//            window.makeKeyAndVisible()
//            self.window = window
//        }
        else {
            self.window = UIWindow(windowScene: windowScene)
            let storyboard = UIStoryboard(name: "Messager", bundle: nil)
            let rootVC = storyboard.instantiateViewController(identifier: "MessageBranch")
            //            let rootNC = UINavigationController(rootViewController: rootVC)
            self.window?.rootViewController = rootVC
            self.window?.makeKeyAndVisible()
        }
        
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

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

