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
    @IBOutlet weak var mostLovedAlbumsTableView: UITableView!
    @IBOutlet weak var viewSelectorButton: UISegmentedControl!
    var mostLovedAlbums: [AlbumData] = []
    var segueData: AlbumData!
    var request = APIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTableView()
        viewSelectorButton.addTarget(self, action: #selector(self.changedViewListener(_:)), for: .valueChanged)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "toplistTableViewCell", for: indexPath) as! AlbumTableViewCell
        
        let imageUrl = URL(string: album.strAlbumThumb!)
       
        cell.albumLabel.text = album.strAlbumStripped
        cell.artistLabel.text = album.strArtist
        cell.albumImageView.kf.setImage(with: imageUrl)
        return cell
    }
    
    func populateTableView() {
        request.fetch(requestUrl: "https://theaudiodb.com/api/v1/json/1/mostloved.php?format=album", completion: { (response) in
            let decoder = JSONDecoder.init()
            let mostLovedAlbumsResponse = try! decoder.decode(MostLoved.self, from: response!)
            for album in mostLovedAlbumsResponse.loved {
                self.mostLovedAlbums.append(album)
            }
            DispatchQueue.main.async {
                self.mostLovedAlbumsTableView.reloadData()
            }
        })
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
        let detailViewController = segue.destination as! DetailViewController
        print("segueData:: ", segueData!)
         detailViewController.albumData = segueData
    }
    
}

