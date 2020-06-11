//
//  SearchViewController.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 10/06/2020.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "searchId"

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? QuizViewCell

       if cell == nil {
           cell = QuizViewCell.createCell()
       }

       DispatchQueue.main.async {
           cell?.setValues(quiz: self.quizzes[indexPath.row])
       }

       return cell!
   }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return self.quizzes.count
       }
       
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 140//Choose your custom row height
       }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           self.navigationController?.pushViewController(QuizScreenViewController(
               quiz: self.quizzes[indexPath.row]),
               animated: false
           )
       }

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var quizTable: UITableView!
    
    let quizService = QuizService()
    
    var quizzes: [Quiz] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.quizTable.delegate = self
        self.quizTable.dataSource = self
        
        // Do any additional setup after loading the view.
    }

    @IBAction func search(_ sender: Any) {
        let searchText = self.searchField.text!
                
        DispatchQueue.main.async {
           self.quizService.retrieveQuizzes(appDelegate: UIApplication.shared.delegate as! AppDelegate, search: searchText) {
               (quizzes) in
               if let quizzes = quizzes {
                   self.quizzes = quizzes
        
                   DispatchQueue.main.async {
                       self.quizTable.reloadData()
                   }
               } else {
                   DispatchQueue.main.async {
                       self.quizTable.isHidden = true
                   }
               }
           }
       }
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
