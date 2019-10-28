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
    @IBOutlet weak var mostLovedAlbumsTableView: UITableView!
    @IBOutlet weak var viewSelectorButton: UISegmentedControl!
    var mostLovedAlbums: [AlbumData] = []
    var segueData: AlbumData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMostLovedAlbums()
        mostLovedAlbumsTableView.reloadData()
        viewSelectorButton.addTarget(self, action: #selector(self.changedViewListener(_:)), for: .valueChanged)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = mostLovedAlbums[indexPath.row]
        segueData = album
        self.performSegue(withIdentifier: "detailViewSegue", sender: self)

        print(mostLovedAlbums[indexPath.row].strAlbumStripped!)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostLovedAlbums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = mostLovedAlbums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        let imageUrl = URL(string: album.strAlbumThumb!)
        let data = try? Data(contentsOf: imageUrl!)
        
        cell.albumLabel.text = album.strAlbumStripped
        cell.artistLabel.text = album.strArtist
        cell.albumImageView.image = UIImage(data: data!)
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
                DispatchQueue.main.async {
                    self.mostLovedAlbumsTableView.reloadData()
                }
            } else if let error = error {
                print(error)
            }
        }
        task.resume()
    }
    
    @objc
    func changedViewListener(_ sender: UISegmentedControl) {
        if(viewSelectorButton.selectedSegmentIndex == 0) {
            mostLovedAlbumsTableView.isHidden = false
        } else {
            mostLovedAlbumsTableView.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        // get a reference to the second view controller
        let detailViewController = segue.destination as! DetailViewController

        // set a variable in the second view controller with the data to pass
        detailViewController.receivedData = segueData
    }
}
