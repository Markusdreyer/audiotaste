//
//  ToplistViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class ToplistViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSelectorButton: UISegmentedControl!
    var mostLovedAlbums: [AlbumData] = []
    var segueData: AlbumData!
    var request = APIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateAlbumData()
        viewSelectorButton.addTarget(self, action: #selector(self.changedViewListener(_:)), for: .valueChanged)
        self.collectionView.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = mostLovedAlbums[indexPath.row]
        
        self.segueData = album
        performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mostLovedAlbums.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = mostLovedAlbums[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "toplistTableViewCell", for: indexPath) as! ToplistTableViewCell
        
        let imageUrl = URL(string: album.strAlbumThumb!)
       
        cell.tableAlbumLabel.text = album.strAlbumStripped
        cell.tableArtistLabel.text = album.strArtist
        cell.tableAlbumImageView.kf.setImage(with: imageUrl)
        return cell
    }
    
    func populateAlbumData() {
        request.fetch(requestUrl: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album", completion: { (response) in
            let decoder = JSONDecoder.init()
            let mostLovedAlbumsResponse = try! decoder.decode(MostLoved.self, from: response!)
            for album in mostLovedAlbumsResponse.loved {
                self.mostLovedAlbums.append(album)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.collectionView.reloadData()
            }
        })
    }
    
    @objc
    func changedViewListener(_ sender: UISegmentedControl) {
        tableView.isHidden = !tableView.isHidden
        collectionView.isHidden = !collectionView.isHidden
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
        print("segueData:: ", segueData!)
         detailViewController.albumData = segueData
    }
    
}

extension ToplistViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mostLovedAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = mostLovedAlbums[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "toplistCollectionViewCell", for: indexPath) as! ToplistCollectionViewCell
        
        let imageUrl = URL(string: album.strAlbumThumb!)
              
        cell.collectionAlbumLabel.text = album.strAlbumStripped
        cell.collectionArtistLabel.text = album.strArtist
        cell.collectionImageView.kf.setImage(with: imageUrl)
        return cell
    }
}

