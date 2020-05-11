//
//  Quiz.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//

import Foundation

class Quiz {
    
    let id: Int
    let title: String
    let description: String
    let category: QuizCategory
    let level: Int
    let image: String
    let questions: Array<Question>
    
    init?(json: Any) {
        if let jsonDict = json as? [String: Any],
            let id = jsonDict["id"] as? Int,
            let title = jsonDict["title"] as? String,
            let description = jsonDict["description"] as? String,
            let category = jsonDict["category"] as? String,
            let level = jsonDict["level"] as? Int,
            let image = jsonDict["image"] as? String,
            let questions = jsonDict["questions"] as? [Any] {
            self.id = id
            self.title = title
            self.description = description
            self.category = QuizCategory(rawValue: category)!
            self.level = level
            self.image = image
            self.questions = questions.flatMap{ Question(json: $0) }
        } else {
            return nil
        }
    }
}
