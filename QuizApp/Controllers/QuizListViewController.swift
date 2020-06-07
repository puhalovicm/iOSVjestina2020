//
//  QuizListViewController.swift
//  QuizApp
//
//  Created by five on 19/05/2020.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let cellId = "cellId"
    
    @IBOutlet weak var quizTable: UITableView!
    @IBOutlet weak var dohvatiButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var funFactLabel: UILabel!
    
    let quizService = QuizService()
    let imageService = ImageService()
    var quizzes: [Quiz] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quizTable.delegate = self
        self.quizTable.dataSource = self
        self.quizTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: self.quizTable.frame.size.width, height: 50))
        self.quizTable.tableFooterView?.backgroundColor = UIColor.lightGray
        
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
    
    @objc func buttonAction(sender: UIButton!) {
        let login = UINavigationController(rootViewController: LoginViewController())
        login.modalPresentationStyle = .fullScreen
        self.navigationController?.present(login, animated: false, completion: {})
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.filter { $0.category == QuizCategory.getCategory(index: section) }.count
    }
    
    func numberOfSections(in: UITableView) -> Int {
        return QuizCategory.count()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(QuizViewCell().frame.size.height)
        
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
    
    @IBAction func fetch() {
        errorLabel.isHidden = true
        quizTable.isHidden = false

        quizService.fetchQuizzes { (quizzes) in
            if let quizzes = quizzes {
                self.quizzes = quizzes
                
                let count = quizzes.map { $0.questions.map { $0.question }.filter{ $0.contains("NBA") }.count }.reduce(0, +)

                DispatchQueue.main.async {
                    self.funFactLabel.text = "Fun fact: \(count)"
                    self.quizTable.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.quizTable.isHidden = true
                    self.errorLabel.isHidden = false
                }
            }
        }
    }
}
