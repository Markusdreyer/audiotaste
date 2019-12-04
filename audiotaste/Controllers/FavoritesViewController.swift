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
    var trackData: [TrackData] = []
    var segueData: AlbumData!

    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(doSomething), for: .valueChanged)
        tableView.refreshControl = refreshControl
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.fetchFavorites()

    }
    
    @objc func doSomething(refreshControl: UIRefreshControl) {
        self.fetchFavorites()
        refreshControl.endRefreshing()
    }
    
    func fetchFavorites() {
        let moc = (UIApplication.shared.delegate as?
        AppDelegate)!.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Favorites_Track>(entityName: "Favorites_Track")
        let favoriteTracks = try! moc.fetch(fetchRequest)
        trackData = []
        for favoriteTrack in favoriteTracks {
            var track = TrackData()
            track.strTrack = favoriteTrack.strTrack
            track.strArtist = favoriteTrack.strArtist
            track.intDuration = favoriteTrack.intDuration
            trackData.append(track)
        }
        
        self.tableView.reloadData()
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackData.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = trackData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let duration = Int(track.intDuration!)
        
        cell.artistLabel.text = track.strArtist
        cell.trackLabel.text = track.strTrack
        cell.runningTime.text = duration!.formatTime.minuteSeconds
        return cell
    }
}


