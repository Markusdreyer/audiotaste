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
        fetchAlbum()
    }
    
    func fetchAlbum() {
        
        let urlSession = URLSession.shared
        let url = URL.init(string:
            "https://theaudiodb.com/api/v1/json/1/searchalbum.php?a=Homework")!
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
                   
            if let data = data {
                let responseString = String.init(data: data, encoding: String.Encoding.utf8)
                       
                let decoder = JSONDecoder.init()
                       
                let albumObject = try! decoder.decode(Album.self, from: data)
                
                //print(responseString)
                print(albumObject.album[0].idAlbum!) //wtf.............
                
            } else if let error = error {
                print(error)
            }
        }
        task.resume()
        
    
    }
}
