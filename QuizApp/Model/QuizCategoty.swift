//
//  QuizCategoty.swift
//  QuizApp
//
//  Created by five on 11/05/2020.
//

import UIKit
import Foundation

enum QuizCategory: String {
    case Sports = "SPORTS"
    case Science = "SCIENCE"
    
    static func getColor(category: QuizCategory) -> UIColor {
        switch category {
        case .Sports:
            return UIColor.blue
        case .Science:
            return UIColor.red
        }
    }
}
