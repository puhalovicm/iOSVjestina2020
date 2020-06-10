//
//  QuizCategoty.swift
//  QuizApp
//
//  Created by five on 11/05/2020.
//

import UIKit
import Foundation

enum QuizCategory: String, CaseIterable {
    case SPORTS = "SPORTS"
    case SCIENCE = "SCIENCE"
    
    static func getColor(category: QuizCategory) -> UIColor {
        switch category {
        case .SPORTS:
            return UIColor.systemOrange
        case .SCIENCE:
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
