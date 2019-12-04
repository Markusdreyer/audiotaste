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
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let artistSection = Array(trackData.keys)[sourceIndexPath.section]
        let tmp = trackData[artistSection]![sourceIndexPath.item]
        trackData[artistSection]?.remove(at: sourceIndexPath.item)
        trackData[artistSection]?.insert(tmp, at: destinationIndexPath.item)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
             let artistSection = Array(trackData.keys)[indexPath.section]
            trackData[artistSection]?.remove(at: indexPath.item)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return trackData.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(trackData.keys)[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let artists = Array(trackData.keys)
        let artistSection = artists[section]
        
        guard let sectionTracks = trackData[artistSection] else { return 0}
        
        return sectionTracks.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let artistSection = Array(trackData.keys)[indexPath.section]
        if let tracksInSection = trackData[artistSection] {
            let duration = Int(tracksInSection[indexPath.row].intDuration!)
             cell.trackLabel.text = tracksInSection[indexPath.row].strTrack
             cell.runningTime.text = duration!.formatTime.minuteSeconds
        }
        return cell
    }
}
