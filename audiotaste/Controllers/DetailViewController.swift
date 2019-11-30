//
//  DetailViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 28/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var albumTitle: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    var trackData: [TrackData] = []
    var albumData: AlbumData!
    var request = APIRequest()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        populateTrackData()
        if albumData.strAlbumThumb != nil {
            let imageUrl = URL(string: albumData.strAlbumThumb!)
            albumImage.kf.setImage(with: imageUrl)
        }
        albumTitle.text = albumData.strAlbumStripped
        artistName.text = albumData.strArtist
    }

    func populateTrackData() {
        request.fetch(requestUrl: "https://theaudiodb.com/api/v1/json/1/track.php?m=\(albumData.idAlbum!)", completion: { (response) in
            let decoder = JSONDecoder.init()
            let trackDataResponse = try! decoder.decode(Track.self, from: response!)
            for track in trackDataResponse.track {
                self.trackData.append(track)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        trackData.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = trackData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailViewTableViewCell", for: indexPath) as! DetailViewTableViewCell
        
        let duration = Int(track.intDuration!)
        
        cell.albumTitle.text = track.strTrack
        cell.runningTime.text = duration!.formatTime.minuteSeconds
        return cell
    }
}

    extension TimeInterval {
        var minuteSeconds: String {
            return String(format:"%d:%02d", minute, second)
        }
        
        var minute: Int {
            return Int((self/60).truncatingRemainder(dividingBy: 60))
        }
        
        var second: Int {
            return Int(truncatingRemainder(dividingBy: 60))
            }
    }

    extension Int {
        var formatTime: Double {
        return Double(self) / 1000
        }
    }
