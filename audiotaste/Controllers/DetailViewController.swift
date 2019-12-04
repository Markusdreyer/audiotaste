//
//  DetailViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 28/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import Kingfisher
import CoreData
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
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTrack = trackData[indexPath.row]
        self.insertFavorite(selectedTrack: selectedTrack)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func insertFavorite(selectedTrack: TrackData) {
        let alert = UIAlertController(title: "Add To Favorites", message: "Would you like to add \(selectedTrack.strTrack!) to favorites?", preferredStyle: .alert)
        let moc = (UIApplication.shared.delegate as?
                        AppDelegate)!.persistentContainer.viewContext
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites_Track", in: moc)!
        
       
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            let favoriteTrack = Favorites_Track.init(entity: entityDescription, insertInto: moc)
                                  
            favoriteTrack.strTrack = selectedTrack.strTrack
            favoriteTrack.strArtist = selectedTrack.strArtist
            favoriteTrack.intDuration = selectedTrack.intDuration
            
            if moc.hasChanges { //to ensure that only unique values are inserted
                do {
                    try moc.save()
                } catch let error {
                    print(error)
                }
            }
        }))
               
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            print("SHOULD NOT PERSIST")
        }))
               
        present(alert, animated: true)
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
