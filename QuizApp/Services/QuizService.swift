//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//

import Foundation

class QuizService {
    
    static let BASE_URL = "https://iosquiz.herokuapp.com/api"
    static let QUIZZES_API = BASE_URL + "/quizzes"
    static let LOGIN_API = BASE_URL + "/session"

    func fetchQuizzes(completion: @escaping (([Quiz]?) -> Void)) {
        if let url = URL(string: QuizService.QUIZZES_API) {
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
    
    func login(username: String, password: String, completion: @escaping ((String?, Int?) -> Void)) {
        if let url = URL(string: QuizService.LOGIN_API) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
        
            // HTTP Request Parameters which will be sent in HTTP Request Body
            let postString = "username=\(username)&password=\(password)";
            // Set HTTP Request Body
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    print("response \(response.statusCode)")
                    
                    if response.statusCode >= 200 && response.statusCode < 300 {
                        if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]

                                if let token = json?["token"] as? String,
                                    let userId = json?["user_id"] as? Int {
                                    completion(token, userId)
                                }
                            } catch {
                                completion(nil, nil)
                            }
                        } else {
                            completion(nil, nil)
                        }
                    } else {
                        completion(nil, nil)
                    }
                } else {
                    completion(nil, nil)
                }
            }
            
            dataTask.resume()
        } else {
            completion(nil, nil)
        }
    }
}
