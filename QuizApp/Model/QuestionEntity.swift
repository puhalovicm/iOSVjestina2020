//
//  QuestionEntity.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 10/06/2020.
//

import Foundation
import CoreData

@objc(QuestionEntity)
class QuestionEntity: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var question: String
    @NSManaged var correct_answer: Int32
    @NSManaged var answers: [NSString]
    @NSManaged var quiz_id: Int32
 
    func update(with question: Question, quizId: Int) {
        self.id = Int32(question.id)
        self.question = question.question
        self.correct_answer = Int32(question.correctAnswer)
        self.answers = question.answers as [NSString]
        self.quiz_id = Int32(quizId)
    }
}

