//
//  LoginViewController.swift
//  QuizApp
//
//  Created by five on 19/05/2020.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var aplikacijaLabel: UILabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    let quizService = QuizService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.aplikacijaLabel.alpha = 0
        self.usernameTextField.alpha = 0
        self.passwordTextField.alpha = 0
        self.loginButton.alpha = 0
        
        self.aplikacijaLabel.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        self.usernameTextField.transform = CGAffineTransform(translationX: -self.usernameTextField.frame.origin.x - self.usernameTextField.frame.width, y: 0)
        self.passwordTextField.transform = CGAffineTransform(translationX: -self.passwordTextField.frame.origin.x - self.passwordTextField.frame.width, y: 0)
        self.loginButton.transform = CGAffineTransform(translationX: -self.loginButton.frame.origin.x - self.loginButton.frame.width, y: 0)

        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseOut], animations: {
            self.aplikacijaLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.aplikacijaLabel.alpha = 1
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut], animations: {
            self.usernameTextField.alpha = 1
            self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.15, options: [.curveEaseOut], animations: {
            self.passwordTextField.alpha = 1
            self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
        }
        
        UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseOut], animations: {
            self.loginButton.alpha = 1
            self.loginButton.transform = CGAffineTransform(translationX: 0, y: 0)
        }) { _ in
        }
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
                userDefaults.set(username, forKey: "username")

                self.animateLogin()
            } else {
                DispatchQueue.main.async {
                    self.errorLabel.isHidden = false
                    self.passwordTextField.text = ""
                }
            }
        })
    }
    
    func animateLogin() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.7, delay: 0.0, options: [.curveEaseOut], animations: {
                self.aplikacijaLabel.alpha = 0
                self.aplikacijaLabel.transform = CGAffineTransform(translationX: 0, y: -self.aplikacijaLabel.frame.origin.y - self.aplikacijaLabel.frame.height)
            }) { _ in
            }
            
            UIView.animate(withDuration: 0.7, delay: 0.1, options: [.curveEaseOut], animations: {
                self.usernameTextField.alpha = 0
                self.usernameTextField.transform = CGAffineTransform(translationX: 0, y: -self.usernameTextField.frame.origin.y - self.usernameTextField.frame.height)
            }) { _ in
            }
            
            UIView.animate(withDuration: 0.7, delay: 0.2, options: [.curveEaseOut], animations: {
                self.passwordTextField.alpha = 0
                self.passwordTextField.transform = CGAffineTransform(translationX: 0, y: -self.passwordTextField.frame.origin.y - self.passwordTextField.frame.height)
            }) { _ in
            }
            
            UIView.animate(withDuration: 0.7, delay: 0.3, options: [.curveEaseOut], animations: {
                self.loginButton.alpha = 0
                self.loginButton.transform = CGAffineTransform(translationX: 0, y: -self.loginButton.frame.origin.y - self.loginButton.frame.height)
            }) { _ in
               DispatchQueue.main.async {
                   let quizList = TabBarViewController()
                   quizList.modalPresentationStyle = .fullScreen
                   self.present(quizList, animated: false, completion: {})
               }
            }
        }
    }
}
