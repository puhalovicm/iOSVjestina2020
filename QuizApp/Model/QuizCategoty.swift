//
//  QuizCategoty.swift
//  QuizApp
//
//  Created by five on 11/05/2020.
//

import UIKit
import Foundation

enum QuizCategory: String, CaseIterable {
    case Sports = "SPORTS"
    case Science = "SCIENCE"
    
    static func getColor(category: QuizCategory) -> UIColor {
        switch category {
        case .Sports:
            return UIColor.systemOrange
        case .Science:
            return UIColor.systemTeal
        }
    }
    
    static func count() -> Int {
        return QuizCategory.allCases.count
    }
    
    static func getCategory(index: Int) -> QuizCategory {
        return QuizCategory.allCases[index]
    }
}
