//
//  Question.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//

import Foundation

class Question {
    
    let id: Int
    let question: String
    let answers: Array<String>
    let correctAnswer: Int
    
    init(questionEntity: QuestionEntity) {
        self.id = Int(questionEntity.id)
        self.question = questionEntity.question
        self.correctAnswer = Int(questionEntity.correct_answer)
        self.answers = questionEntity.answers as [String]
    }
    
    init?(json: Any) {        
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let question = jsonDict["question"] as? String,
            let answers = jsonDict["answers"] as? [String],
            let correctAnswer = jsonDict["correct_answer"] as? Int {
                self.id = id
                self.question = question
                self.answers = answers
                self.correctAnswer = correctAnswer
        } else {
            return nil
        }
    }
}
