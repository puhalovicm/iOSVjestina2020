//
//  Question2View.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 05/06/2020.
//

import UIKit

class QuestionView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var correctAnswer: Int = -1
    var delegate: QuestionViewDelegate? = nil
    
    func set(question: Question) {
        questionLabel.text = question.question
        button1.setTitle(question.answers[0], for: .normal)
        button2.setTitle(question.answers[1], for: .normal)
        button3.setTitle(question.answers[2], for: .normal)
        button4.setTitle(question.answers[3], for: .normal)
        correctAnswer = question.correctAnswer
    }
    
    
    @IBAction func buttonPressed(_ sender: Any) {        
        if answer(button: (sender as AnyObject).tag) {
            self.backgroundColor = UIColor.green
            delegate?.questionWasAnswered(correct: true)
        } else {
            self.backgroundColor = UIColor.red
            delegate?.questionWasAnswered(correct: false)
        }
        
        button1.isEnabled = false
        button2.isEnabled = false
        button3.isEnabled = false
        button4.isEnabled = false
    }
        
    func answer(button: Int) -> Bool {
        return button == correctAnswer
    }
}
