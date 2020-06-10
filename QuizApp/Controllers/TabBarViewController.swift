//
//  TabBarViewController.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 10/06/2020.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstViewController = UINavigationController(rootViewController: QuizListViewController())
                
        firstViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)

        let secondViewController = SearchViewController()

        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        
        let thirdViewController = SettingsViewController()

        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 2)
        
        let tabBarList = [firstViewController, secondViewController, thirdViewController]

        viewControllers = tabBarList
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
