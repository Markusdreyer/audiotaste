//
//  ToplistViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import UIKit

class ToplistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var mostLovedAlbums: [AlbumData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMostLovedAlbums()
        
        print("Helloo")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let album = mostLovedAlbums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        //cell.albumLabel.text = album.strAlbumStripped
        //cell.artistLabel.text = album.strArtist
        //cell.albumImageView.image = UIImage(named: album.strAlbumThumb!)
        
        cell.albumLabel.text = "Album title"
        cell.artistLabel.text = "Artist name"
        //cell.albumImageView.image = UIImage(named: album.strAlbumThumb!)
        
        print("fjgeirg")
        
        return cell
    }
    
    
    
    func fetchMostLovedAlbums() {
        let urlSession = URLSession.shared
        let url = URL.init(string:
            "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album")!
        
        let task = urlSession.dataTask(with: url) { (data, response, error) in
                   
            if let data = data {
                _ = String.init(data: data, encoding: String.Encoding.utf8)
                       
                let decoder = JSONDecoder.init()
                       
                let mostLovedAlbumsResponse = try! decoder.decode(MostLoved.self, from: data)
                
                for album in mostLovedAlbumsResponse.loved {
                    self.mostLovedAlbums.append(album)
                }
                
            
            } else if let error = error {
                print(error)
            }
        }
        task.resume()
        
    }
    
    

}
