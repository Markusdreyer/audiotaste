//
//  Favorites.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var albumData: [AlbumData] = []
    var segueData: AlbumData!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    
        let album = albumData[indexPath.row]
    
        self.segueData = album
        performSegue(withIdentifier: "detailViewSegue", sender: self)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let album = albumData[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "toplistTableViewCell", for: indexPath) as! TableViewCell
    
    let imageUrl = URL(string: album.strAlbumThumb!)
   
    cell.tableAlbumLabel.text = album.strAlbumStripped
    cell.tableArtistLabel.text = album.strArtist
    cell.tableAlbumImageView.kf.setImage(with: imageUrl)
    return cell
    }
}
