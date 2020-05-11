//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//

import Foundation

class QuizService {
    
    let QUIZZES_API = "https://iosquiz.herokuapp.com/api/quizzes"
    
    func fetchQuizzes(completion: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: QUIZZES_API) {
            let request = URLRequest(url: url)
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] 
                        if let quizzes = json?["quizzes"] as? NSArray {
                            var quizArray: [Quiz] = []
                            quizzes.forEach {
                                if let q = Quiz(json: $0) {
                                    quizArray.append(q)
                                }
                            }
                            
                            completion(quizArray)
                        }
                    } catch {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            }
            
            dataTask.resume()
        } else {
            completion(nil)
        }
    }
}
