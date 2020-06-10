//
//  LeaderboardViewController.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 09/06/2020.
//

import UIKit

class LeaderboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let cellId = "scoreId"
    
    @IBOutlet weak var laderboardTable: UITableView!
    
    let quiz: Quiz
    
    let quizService = QuizService()
    var scores: [QuizScore] = []
       
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
   
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.laderboardTable.delegate = self
        self.laderboardTable.dataSource = self
        
        quizService.fetchLeaderboard(quizId: quiz.id) { quizScores in
            if let quizScores = quizScores {
                self.scores = Array(quizScores.filter { $0.score != nil }.prefix(20))
                DispatchQueue.main.async {
                    self.laderboardTable.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return scores.count
       }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {       
       return 70//Choose your custom row height
   }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? ScoreViewCell

       if cell == nil {
           cell = ScoreViewCell.createCell()
       }
    
       DispatchQueue.main.async {
           cell?.setLabels(score: self.scores[indexPath.row].score!, username: self.scores[indexPath.row].username)
       }

       return cell!
   }
}
