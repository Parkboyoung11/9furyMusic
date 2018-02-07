//
//  ApiService.swift
//  9furyMusic
//
//  Created by VuHongSon on 1/31/18.
//  Copyright © 2018 VuHongSon. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    static let sharedInstance = ApiService()
    
    let baseUrl = "http://khanhnv.xyz/Son"
    
    func fetchHome(_ completion: @escaping ([Music]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/home.php", completion)
    }
    
    func fetchSearch(keyWord: String, _ completion: @escaping ([Music]) -> ()) {
        fetchFeedForUrlString("\(baseUrl)/search.php?s=\(keyWord)", completion)
//        fetchFeedForUrlString("\(baseUrl)/search.php?s=my love", completion)
    }
    
//    func fetchTrendingFeed(_ completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString("\(baseUrl)/trending.json", completion)
//    }
//    
//    func fetchSubscriptionFeed(_ completion: @escaping ([Video]) -> ()) {
//        fetchFeedForUrlString("\(baseUrl)/subscriptions.json", completion)
//    }
    
    func fetchFeedForUrlString(_ urlString: String, _ completion: @escaping ([Music]) -> ()) {
        let url = URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, respone, error) in
            if error != nil {
                print(error ?? String())
                return
            }
            do {
                if let unwrappedData = data, let jsonDictionaries = try JSONSerialization.jsonObject(with: unwrappedData, options: .mutableContainers) as? [[String: String]] {
                    DispatchQueue.main.async(execute: {
                        completion(jsonDictionaries.map({return Music(dictionary: $0)}))
                    })
                    
                }
            }catch let jsonError{
                print(jsonError)
            }
            
            }.resume()
    }
}
