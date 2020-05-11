//
//  ImageService.swift
//  QuizApp
//
//  Created by five on 11/05/2020.
//

import UIKit
import Foundation

class ImageService {
        
    func fetchImage(imageUrl: String, completion: @escaping ((UIImage?) -> Void)) {
        if let url = URL(string: imageUrl) {
                
        let request = URLRequest(url: url)
                
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let data = data {
                let image = UIImage(data: data)
                completion(image)
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
