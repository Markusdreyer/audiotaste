//
//  Favorites.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import UIKit
import CoreData


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var trackData = [String: [TrackData]]()
    var segueData: AlbumData!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchFavorites()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFavorites()

    }
    
    func fetchFavorites() {
        let moc = (UIApplication.shared.delegate as?
        AppDelegate)!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Favorites_Track>(entityName: "Favorites_Track")
        let favoriteTracks = try! moc.fetch(fetchRequest)
        trackData.removeAll()
        for favoriteTrack in favoriteTracks {
            var track = TrackData()
            track.strTrack = favoriteTrack.strTrack
            track.strArtist = favoriteTrack.strArtist
            track.intDuration = favoriteTrack.intDuration
            trackData[track.strArtist, default: []].append(track)
            
        }
        self.tableView.reloadData()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return trackData.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(trackData.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let artists = Array(trackData.keys)
        let sectionArtist = artists[section]
        
        guard let sectionTracks = trackData[sectionArtist] else { return 0}
        
        return sectionTracks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let sectionArtist = Array(trackData.keys)[indexPath.section]
        if let tracksInSection = trackData[sectionArtist] {
            let duration = Int(tracksInSection[indexPath.row].intDuration!)
             cell.trackLabel.text = tracksInSection[indexPath.row].strTrack
             cell.runningTime.text = duration!.formatTime.minuteSeconds
        }
        return cell
    }
}
