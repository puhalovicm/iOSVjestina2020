//
//  QuizEntity.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 10/06/2020.
//

import Foundation
import CoreData

@objc(QuizEntity)
class QuizEntity: NSManagedObject {
    
    @NSManaged var id: Int32
    @NSManaged var title: String
    @NSManaged var quiz_description: String
    @NSManaged var category: String
    @NSManaged var level: Int32
    @NSManaged var image: String
    
    func update(with quiz: Quiz) {
        self.id = Int32(quiz.id)
        self.title = quiz.title
        self.quiz_description = quiz.description
        self.category = String(describing: quiz.category)
        self.level = Int32(quiz.level)
        self.image = quiz.image        
    }
}
