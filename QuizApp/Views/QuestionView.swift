//
//  QuestionView.swift
//  QuizApp
//
//  Created by five on 11/05/2020.
//

import UIKit
import Foundation

class QuestionView: UIView {
       
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    var correctAnswer: Int = -1
    
    func set(question: Question) {
        questionLabel.text = question.question
        button1.setTitle(question.answers[0], for: .normal)
        button2.setTitle(question.answers[1], for: .normal)
        button3.setTitle(question.answers[2], for: .normal)
        button4.setTitle(question.answers[3], for: .normal)
        correctAnswer = question.correctAnswer
    }
    
    
    @IBAction func button1Clicked(_ sender: Any) {
        if answer(button: 0) {
            self.backgroundColor = UIColor.green
        } else {
            self.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func button2Clicked(_ sender: Any) {
        if answer(button: 1) {
            self.backgroundColor = UIColor.green
        } else {
            self.backgroundColor = UIColor.red
        }
    }
    
    
    @IBAction func button3Clicked(_ sender: Any) {
        if answer(button: 2) {
            self.backgroundColor = UIColor.green
        } else {
            self.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func button4Clicked(_ sender: Any) {
//        button1.tag
        if answer(button: 3) {
            self.backgroundColor = UIColor.green
        } else {
            self.backgroundColor = UIColor.red
        }
    }
    
    func answer(button: Int) -> Bool {
        return button == correctAnswer
    }
}
