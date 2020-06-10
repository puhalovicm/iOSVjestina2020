//
//  AppDelegate.swift
//  QuizApp
//
//  Created by five on 09/05/2020.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolver error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let userDefaults = UserDefaults.standard
        if let _ = userDefaults.string(forKey: "token"),
            let _ = userDefaults.string(forKey: "userId") {
            window?.rootViewController = TabBarViewController()
        } else {
            window?.rootViewController = UINavigationController(rootViewController: LoginViewController())
        }
        
        window?.makeKeyAndVisible()
  
        return true
    }
}
