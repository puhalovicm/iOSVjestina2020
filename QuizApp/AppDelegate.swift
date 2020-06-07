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
        window = UIWindow(frame: UIScreen.main.bounds)

        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.string(forKey: "token"),
            let _ = userDefaults.string(forKey: "userId") {
            window?.rootViewController = UINavigationController(rootViewController: QuizListViewController())
        } else {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        window?.makeKeyAndVisible()
                
        return true
    }
}
