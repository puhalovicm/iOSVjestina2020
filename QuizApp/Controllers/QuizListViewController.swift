//
//  QuizListViewController.swift
//  QuizApp
//
//  Created by five on 19/05/2020.
//

import UIKit
import Reachability

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellId = "quizId"
    
    @IBOutlet weak var quizTable: UITableView!
    @IBOutlet weak var funFactLabel: UILabel!
    
    let quizService = QuizService()
    let imageService = ImageService()
    var quizzes: [Quiz] = []
    
    var refreshControl = UIRefreshControl()
    let reachability = try! Reachability()

    override func viewDidLoad() {
        super.viewDidLoad()

       reachability.whenReachable = { reachability in
           if reachability.connection == .wifi {
               print("Reachable via WiFi")
           } else {
               print("Reachable via Cellular")
           }
       }
       reachability.whenUnreachable = { _ in
           print("Not reachable")
            let alertController = UIAlertController(title: "Error", message: "Network unreachable", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
       }

       do {
           try reachability.startNotifier()
       } catch {
           print("Unable to start notifier")
       }
        
        DispatchQueue.main.async {
            self.quizService.retrieveQuizzes(appDelegate: UIApplication.shared.delegate as! AppDelegate) {
                (quizzes) in
                if let quizzes = quizzes {
                    self.quizzes = quizzes

                    let count = quizzes.map { $0.questions.map { $0.question }.filter{ $0.contains("NBA") }.count }.reduce(0, +)

                    DispatchQueue.main.async {
                        self.funFactLabel.text = "Fun fact: \(count)"
                        self.quizTable.reloadData()

                        self.quizService.saveQuizzes(quizzes: quizzes, appDelegate: UIApplication.shared.delegate as! AppDelegate)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.quizTable.isHidden = true
                    }
                }
            }
        }
        
        fetchQuizzes()
        
        self.quizTable.delegate = self
        self.quizTable.dataSource = self
        self.quizTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.quizTable.frame.size.width, height: 50))
        self.quizTable.tableFooterView?.backgroundColor = UIColor.lightGray
        
        refreshControl.attributedTitle = NSAttributedString(string: "Fetching quizzes...")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        quizTable.addSubview(refreshControl)
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.quizTable.tableFooterView?.addSubview(button)
        
        button.leftAnchor.constraint(equalTo: self.quizTable.tableFooterView!.leftAnchor, constant: 10).isActive = true
        button.rightAnchor.constraint(equalTo: self.quizTable.tableFooterView!.rightAnchor, constant: -10).isActive = true
        button.topAnchor.constraint(equalTo: self.quizTable.tableFooterView!.topAnchor, constant: 10).isActive = true
        button.bottomAnchor.constraint(equalTo:  self.quizTable.tableFooterView!.bottomAnchor, constant: -10).isActive = true
        
        self.quizTable.tableFooterView?.layoutIfNeeded()
        view.layoutIfNeeded()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        fetchQuizzes()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = LoginViewController()
    }
    
    func numberOfSections(in: UITableView) -> Int {
        return QuizCategory.count()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.filter { $0.category == QuizCategory.getCategory(index: section) }.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {        
        return 140//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? QuizViewCell

        if cell == nil {
            cell = QuizViewCell.createCell()
        }

        DispatchQueue.main.async {
            cell?.setValues(quiz: self.quizzes.filter { $0.category == QuizCategory.getCategory(index: indexPath.section) }[indexPath.row])
        }

        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        view.backgroundColor = QuizCategory.getColor(category: QuizCategory.getCategory(index: section))
      
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = QuizCategory.getCategory(index: section).rawValue
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true

        view.layoutIfNeeded()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(QuizScreenViewController(
            quiz: self.quizzes.filter { $0.category == QuizCategory.getCategory(index: indexPath.section) }[indexPath.row]),
            animated: false
        )
    }
    
    func fetchQuizzes() {
        if (reachability.connection == .unavailable) {
            let alertController = UIAlertController(title: "Error", message: "Network unreachable", preferredStyle: .alert)
            let action1 = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction) in }
            alertController.addAction(action1)
            self.present(alertController, animated: true, completion: nil)
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
                
        quizTable.isHidden = false

        quizService.fetchQuizzes { (quizzes) in
            if let quizzes = quizzes {
                self.quizzes = quizzes
                
                let count = quizzes.map { $0.questions.map { $0.question }.filter{ $0.contains("NBA") }.count }.reduce(0, +)

                DispatchQueue.main.async {
                    self.funFactLabel.text = "Fun fact: \(count)"
                    self.quizTable.reloadData()
                    
                    self.quizService.saveQuizzes(quizzes: quizzes, appDelegate: UIApplication.shared.delegate as! AppDelegate)
                }
            } else {
                DispatchQueue.main.async {
                    self.quizTable.isHidden = true
                }
            }
            
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
}
