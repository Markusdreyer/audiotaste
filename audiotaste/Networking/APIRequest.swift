//
//  APIRequest.swift
//  audiotaste
//
//  Created by Markus Dreyer on 27/11/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

class APIRequest {
    
    public func fetch(requestUrl: String, completion: @escaping (_ response: Data?) -> Void) {
        let urlSession = URLSession.shared
        let url = URL.init(string: requestUrl)!
        let task = urlSession.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                return
            }
            completion(data!)
        }
        task.resume()
    }
    
}
