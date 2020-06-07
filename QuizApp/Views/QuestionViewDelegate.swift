//
//  QuestionViewDelegate.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 07/06/2020.
//

import Foundation

protocol QuestionViewDelegate {
    func questionWasAnswered(correct: Bool)
}
