//
//  DetailViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 28/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    var albumData: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let imageUrl = URL(string: albumData.strAlbumThumb!)
        //let data = try? Data(contentsOf: imageUrl!)
        
        //albumImage.image = UIImage(data: data!)
        albumTitle.text = albumData
        //artistName.text = albumData.strArtist
        print(albumData)
    }
}
