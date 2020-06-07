//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 19/05/2020.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let quizService = QuizService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func login(_ sender: Any) {
        guard let username = self.usernameTextField.text else {
          return
        }

        guard let password = self.passwordTextField.text else {
            return
        }
        
        self.errorLabel.isHidden = true
        
        quizService.login(username: username, password: password, completion: {
            (token, userId) in
            if let token = token,
                let userId = userId {

                let userDefaults = UserDefaults.standard
                userDefaults.set(token, forKey: "token")
                userDefaults.set(userId, forKey: "userId")

                DispatchQueue.main.async {
                    let quizList = UINavigationController(rootViewController: QuizListViewController())
                    quizList.modalPresentationStyle = .fullScreen
                    self.present(quizList, animated: false, completion: {})
                }
            } else {
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                    self.passwordTextField.text = ""
                }
            }
        })
    }
}
