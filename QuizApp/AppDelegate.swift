//
//  AppDelegate.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = LoginViewController()
        
        let navigationController = UINavigationController(rootViewController: vc)
        
        navigationController.providesPresentationContextTransitionStyle = false;
        navigationController.definesPresentationContext = false;
        navigationController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        
        window?.rootViewController = navigationController
                
//        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()

        return true
    }



}

