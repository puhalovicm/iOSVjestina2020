//
//  QuizService.swift
//  QuizApp
//
//  Created by five on 10/05/2020.
//

import Foundation
import CoreData

class QuizService {
    
    static let BASE_URL = "https://iosquiz.herokuapp.com/api"
    static let QUIZZES_API = BASE_URL + "/quizzes"
    static let LOGIN_API = BASE_URL + "/session"
    static let RESULT_API = BASE_URL + "/result"
    static let LEADERBOARD_API = BASE_URL + "/score?quiz_id="

    func saveQuizzes(quizzes: [Quiz], appDelegate: AppDelegate) {
        deleteQuizzes(appDelegate: appDelegate)
        
        let quizEntity = NSEntityDescription.entity(forEntityName: "QuizEntity", in: appDelegate.persistentContainer.viewContext)!
        let questionEntity = NSEntityDescription.entity(forEntityName: "QuestionEntity", in: appDelegate.persistentContainer.viewContext)!

        for quiz in quizzes {
            let quizObject = NSManagedObject(entity: quizEntity, insertInto: appDelegate.persistentContainer.viewContext) as! QuizEntity
            quizObject.update(with: quiz)
            
            for question in quiz.questions {
                let questionObject = NSManagedObject(entity: questionEntity, insertInto: appDelegate.persistentContainer.viewContext) as! QuestionEntity

                questionObject.update(with: question, quizId: quiz.id)
            }
            
        }
        
        appDelegate.saveContext()
    }
    
    func deleteQuizzes(appDelegate: AppDelegate) {
        let quizFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizEntity")
        let questionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionEntity")

        do {
            let questionResult = try appDelegate.persistentContainer.viewContext.fetch(questionFetchRequest)
            let quizResult = try appDelegate.persistentContainer.viewContext.fetch(quizFetchRequest)
                                    
            for data in quizResult {
                appDelegate.persistentContainer.viewContext.delete(data as! NSManagedObject)
            }
            
            for data in questionResult {
                appDelegate.persistentContainer.viewContext.delete(data as! NSManagedObject)
            }
        } catch {
        }
    }
    
    func retrieveQuizzes(appDelegate: AppDelegate, completion: @escaping (([Quiz]?) -> Void)) {
        let quizFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizEntity")
        let questionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionEntity")

        do {
            let questionResult = try appDelegate.persistentContainer.viewContext.fetch(questionFetchRequest)
            
            let questions = (questionResult as! [QuestionEntity]).map { Question(questionEntity: $0) }
            
            let quizResult = try appDelegate.persistentContainer.viewContext.fetch(quizFetchRequest)
                        
            var quizzes: [Quiz] = []
            
            for data in quizResult as! [QuizEntity] {
                let quiz = Quiz(quizEntity: data, questions: (questionResult as! [QuestionEntity]).filter{ $0.quiz_id == data.id })
                quizzes.append(quiz)
            }
            
            completion(quizzes)
        } catch {
            completion(nil)
        }
    }
    
    func retrieveQuizzes(appDelegate: AppDelegate, search: String, completion: @escaping (([Quiz]?) -> Void)) {
        let quizFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuizEntity")
        let questionFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "QuestionEntity")

        let titlePredicate = NSPredicate(format: "title CONTAINS %@", search)
        let decriptionPredicate = NSPredicate(format: "quiz_description CONTAINS %@", search)

        let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [titlePredicate, decriptionPredicate])
        
        quizFetchRequest.predicate = orPredicate
        
        do {
            let questionResult = try appDelegate.persistentContainer.viewContext.fetch(questionFetchRequest)
            
            let questions = (questionResult as! [QuestionEntity]).map { Question(questionEntity: $0) }
            
            let quizResult = try appDelegate.persistentContainer.viewContext.fetch(quizFetchRequest)
                        
            var quizzes: [Quiz] = []
            
            for data in quizResult as! [QuizEntity] {
                let quiz = Quiz(quizEntity: data, questions: (questionResult as! [QuestionEntity]).filter{ $0.quiz_id == data.id })
                quizzes.append(quiz)
            }
            
            completion(quizzes)
        } catch {
            completion(nil)
        }
    }
    
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
    
    func sendResult(quizId: Int, userId: Int, time: Double, correctAnswers: Int, completion: @escaping ((ServerResponse?) -> Void)) {
        if let url = URL(string: QuizService.RESULT_API) {
            var request = URLRequest(url: url)
            
            let userDefaults = UserDefaults.standard
            
            request.httpMethod = "POST"
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let token = userDefaults.string(forKey: "token") else { return }
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")
            
            let parameters: [String: Any] = [
                "quiz_id": quizId,
                "user_id": userId,
                "time": time,
                "no_of_correct": correctAnswers
            ]
            do {
               request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
           } catch let error {
                completion(nil)
               print(error.localizedDescription)
           }
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let response = response as? HTTPURLResponse {
                    completion(ServerResponse(rawValue: response.statusCode))
                } else {
                    completion(nil)
                }
            }
            
            dataTask.resume()
        } 
    }
    
    func fetchLeaderboard(quizId: Int, completion: @escaping (([QuizScore]?) -> Void)) {
        if let url = URL(string: QuizService.LEADERBOARD_API + String(quizId)) {
            var request = URLRequest(url: url)

            let userDefaults = UserDefaults.standard
            request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
            guard let token = userDefaults.string(forKey: "token") else { return }
            request.setValue("\(token)", forHTTPHeaderField: "Authorization")

            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let data = data {
                    do {
                        let decoder = JSONDecoder()
                        decoder.keyDecodingStrategy = .useDefaultKeys
                        
                        let res = try decoder.decode([QuizScore].self, from: data)
                        completion(res)
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
