//
//  ServerResponse.swift
//  QuizApp
//
//  Created by Mateo Puhalović on 07/06/2020.
//

import Foundation

enum ServerResponse: Int, CaseIterable {
    typealias RawValue = Int
    
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case BadRequest = 400
    case Success = 200
}
