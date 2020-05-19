//
//  QuizListViewController.swift
//  QuizApp
//
//  Created by five on 19/05/2020.
//

import UIKit

class QuizListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var quizTable: UITableView!
    @IBOutlet weak var dohvatiButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var funFactLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var quizImage: UIImageView!
    @IBOutlet weak var questionViewContainer: UIView!

    let quizService = QuizService()
    let imageService = ImageService()
    var quizzes: Array<Quiz> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.quizTable.delegate = self
        self.quizTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.quizzes.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200;//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizItem") as! QuizItemView

        print(quizzes[indexPath.row].title)

        DispatchQueue.main.async {
            cell.titleLabel?.text = self.quizzes[indexPath.row].title
            cell.descriptionLabel?.text = self.quizzes[indexPath.row].description
            cell.levelLabel?.text = String(repeating:"*", count:self.quizzes[indexPath.row].level)
            cell.backgroundColor = QuizCategory.getColor(category: self.quizzes[indexPath.row].category)

            self.imageService.fetchImage(imageUrl: self.quizzes[indexPath.row].image, completion: {
                (image) in
                DispatchQueue.main.async {
                    cell.quizImageView?.image = image
                }
            })
        }

        return cell
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
                    self.titleLabel.text = quizzes[0].title
                    self.titleLabel.backgroundColor = QuizCategory.getColor(category: quizzes[0].category)

                    self.imageService.fetchImage(imageUrl: quizzes[0].image, completion: {
                       (image) in
                        DispatchQueue.main.async {
                            self.quizImage?.image = image
                            self.quizImage.backgroundColor = QuizCategory.getColor(category: quizzes[0].category)
                        }
                   })

                   if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
                        self.questionViewContainer.addSubview(customView)
                        customView.set(question: quizzes[0].questions[0])
                        self.questionViewContainer.bounds = customView.frame
                    }
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

//class QuizItemView: UITableViewCell {
//
//    @IBOutlet weak var quizImageView: UIImageView?
//    @IBOutlet weak var titleLabel: UILabel?
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var levelLabel: UILabel!
//}
