//
//  PostController.swift
//  whyIOS
//
//  Created by Ben Huggins on 2/6/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class PostController{
    
    static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    
    static func fetchPosts(completion: @escaping (([Post]?) -> Void)) {
        
        
        guard var unwrappedURL = baseURL else {completion(nil);return }
        unwrappedURL.appendPathExtension("json")
        var urlRequest = URLRequest(url: unwrappedURL)
        
        urlRequest.httpMethod = "GET"
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, urlRequest, error) in
            if let error = error {
                print("error retrieving post from the web \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let data = data else {
                print("there was no data")
                completion(nil) 
                return
            }
            do {
                let jsonDecoder = JSONDecoder()
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                let posts = postsDictionary.compactMap { $1 }
                completion(posts)
                return
            }catch let error {
                
                print("Error decoding posts \(error.localizedDescription)")
                completion(nil)
                return
                
            }
            }.resume()
        
    }
    
    static func postReason(name: String, reason: String, cohort: String, completion: @escaping ((Bool) -> Void)) {
        
        guard let fullURL = baseURL else {completion(false); return}
        let getterEndpoint = fullURL.appendingPathExtension("json")
        
        let post = Post(name: name, reason: reason, cohort: cohort)
        
        var postData: Data
        
        do{
            let jsonEncoder = JSONEncoder()
            postData = try jsonEncoder.encode(post)
            completion(true)
        }catch {
            print("error \(error.localizedDescription)")
            completion(false)
            return
        }
        
        var urlRequest = URLRequest(url: getterEndpoint)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = postData
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, _, error) in
            if let error = error {
                print("error \(error.localizedDescription)")
                completion(false)
                return
            }
            
        }
        dataTask.resume()
    }
    
    
}



