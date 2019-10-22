//
//  ToplistViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import UIKit

class ToplistViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        fetchTopAlbums()
    }
    
    func fetchTopAlbums() {
        
        let urlSession = URLSession.shared
        let url = URL.init(string:
            "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")!
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
                   
            if let data = data {
                let responseString = String.init(data: data, encoding: String.Encoding.utf8)
                       
                let decoder = JSONDecoder.init()
                       
                //let albumObject = try! decoder.decode(Album.self, from: data)
                
                print(responseString)
                //print(albumObject)
                
            } else if let error = error {
                print(error)
            }
        }
        task.resume()
        
    
    }
}
