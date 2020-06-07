//
//  QuizScreenViewController.swift
//  QuizApp
//
//  Created by five on 20/05/2020.
//

import Kingfisher
import UIKit

class QuizScreenViewController: UIViewController, QuestionViewDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var correctLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    let quizService = QuizService()
    
    var scrollView: UIScrollView!
    var currentQuestion = 0
    var correctAnswers = 0
    var startTime: DispatchTime? = nil

    let quiz: Quiz
    
    init(quiz: Quiz) {
        self.quiz = quiz
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = quiz.title
        titleLabel.backgroundColor = QuizCategory.getColor(category: quiz.category)
        imageView.kf.setImage(with: URL(string: quiz.image))
        
        scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false;
        scrollView.isPagingEnabled = true
        scrollView.backgroundColor = UIColor.black
        view.addSubview(scrollView)
        
        self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true;
        self.scrollView.topAnchor.constraint(equalTo: self.startButton.bottomAnchor, constant: 10).isActive = true;
        self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true;
        self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true;
                
        self.scrollView.showsHorizontalScrollIndicator = false
        
        self.scrollView.contentSize = CGSize(width: 1000, height: 1000)

        scrollView.isUserInteractionEnabled = true
        scrollView.isExclusiveTouch = true
        scrollView.canCancelContentTouches = false;
        scrollView.delaysContentTouches = false;
        
        scrollView.setNeedsLayout()
        
        scrollView.isHidden = true
    }
    
    @IBAction func startQuiz(_ sender: Any) {
        scrollView.isHidden = false
        timeLabel.isHidden = true
        correctLabel.isHidden = true
        loadQuestion(index: 0)
        startButton.isEnabled = false
        startTime = DispatchTime.now()
    }
    
    func questionWasAnswered(correct: Bool) {
        if (correct) {
            correctAnswers += 1
        }
        
        currentQuestion += 1
        
        if (self.currentQuestion < self.quiz.questions.count) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.loadQuestion(index: self.currentQuestion)
            }
        } else {
            let endTime = DispatchTime.now()
            let nanoTime = endTime.uptimeNanoseconds - startTime!.uptimeNanoseconds // <<<<< Difference in nano seconds (UInt64)
            let timeInterval = Double(nanoTime) / 1_000_000_000
            
            let userDefaults = UserDefaults.standard
            
            quizService.sendResult(quizId: quiz.id, userId: Int(userDefaults.string(forKey: "userId")!)!, time: timeInterval, correctAnswers: self.correctAnswers) { serverResponse in

                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            DispatchQueue.main.async {
                self.timeLabel.isHidden = false
                self.timeLabel.text = "Time: \(timeInterval)"
                
                self.correctLabel.isHidden = false
                self.correctLabel.text = "Correct answers: \(self.correctAnswers)"
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.scrollView.isHidden = true
            }
        }
    }
    
    func loadQuestion(index: Int) {
        if let customView = Bundle.main.loadNibNamed("QuestionView", owner: self, options: nil)?.first as? QuestionView {
            customView.set(question: quiz.questions[currentQuestion])
            customView.delegate = self
            customView.frame = CGRect(x: CGFloat(index)*scrollView.frame.size.width, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            scrollView.addSubview(customView)
            scrollView.contentSize = CGSize(width: CGFloat(currentQuestion + 1) * customView.bounds.width, height: customView.bounds.height)
            scrollView.contentOffset = CGPoint(x:CGFloat(index)*scrollView.frame.size.width, y: self.scrollView.contentOffset.y)
        }
    }
}
