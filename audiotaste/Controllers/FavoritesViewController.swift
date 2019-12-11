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
    @IBOutlet weak var collectionView: UICollectionView!
    var trackData = [String: [TrackData]]()
    var recommendations: [Info] = []
    var segueData: AlbumData!
    var request = APIRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.collectionView.layer.borderColor = UIColor.gray.cgColor
        self.collectionView.layer.borderWidth = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchFavorites()
        if(trackData.count > 0) {
            fetchRecommendations()
            collectionView.isHidden = false
        } else {
            collectionView.isHidden = true
        }
    }
    
    @IBAction func editButton(_ sender: UIBarButtonItem) {
        self.tableView.isEditing = !self.tableView.isEditing
        sender.title = (self.tableView.isEditing) ? "Done" : "Edit"
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
    
    func fetchRecommendations() {
        recommendations.removeAll()
        let favoriteArtists = Array(trackData.keys)
        var queryString: String = ""
        for artist in favoriteArtists {
            let ampersandParsed = artist.replacingOccurrences(of: "&", with: "%26")
            let parsedArtistName = ampersandParsed.replacingOccurrences(of: " ", with: "+")
            queryString.append(contentsOf: parsedArtistName + "%2C")
        }
        
        request.fetch(requestUrl: "https://tastedive.com/api/similar?q=\(queryString)&type=music&k=350372-Audiotas-N1N3TG7M", completion: { (response) in
            let decoder = JSONDecoder.init()
            let recommendationResponse = try! decoder.decode(Recommendation.self, from: response!)
            for recommendation in recommendationResponse.similar.results {
                self.recommendations.append(recommendation)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        })
        collectionView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        let artistSection = Array(trackData.keys)[sourceIndexPath.section]
        let tmp = trackData[artistSection]![sourceIndexPath.item]
        trackData[artistSection]?.remove(at: sourceIndexPath.item)
        
        if(Array(trackData.keys)[proposedDestinationIndexPath.section] == artistSection) {
            trackData[artistSection]?.insert(tmp, at: proposedDestinationIndexPath.item)
            return proposedDestinationIndexPath
        } else {
            trackData[artistSection]?.insert(tmp, at: sourceIndexPath.item)
            return sourceIndexPath
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle != .delete) {
            return
        }
        
        let artistSection = Array(self.trackData.keys)[indexPath.section]
        let predicate = self.trackData[artistSection]![indexPath.item].strTrack
        
        let alert = UIAlertController(title: "Remove from Favorites", message: "Are you sure you want to delete \"\(predicate!)\" from favorites?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
            let moc = (UIApplication.shared.delegate as?
            AppDelegate)!.persistentContainer.viewContext
              
            let fetchRequest = NSFetchRequest<Favorites_Track>(entityName: "Favorites_Track")
            fetchRequest.predicate = NSPredicate.init(format: "strTrack like %@", predicate!)
            let result = try! moc.fetch(fetchRequest)
            moc.delete(result.first!)
            try! moc.save()
            
            if(self.trackData[artistSection]?.count == 1) {
                self.trackData.removeValue(forKey: artistSection)
                tableView.deleteSections(NSIndexSet.init(index: indexPath.section) as IndexSet, with: .left)
            } else {
                self.trackData[artistSection]?.remove(at: indexPath.item)
                self.tableView.deleteRows(at: [indexPath], with: .left)
            }
            
            DispatchQueue.main.async {
                if(self.trackData.count > 0) {
                    self.fetchRecommendations()
                    self.collectionView.isHidden = false
                } else {
                    self.collectionView.isHidden = true
                }
            }
        }))
               
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            return
        }))
        
        present(alert, animated: true)
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

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let recommendation = recommendations[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recommendedCollectionViewCell", for: indexPath) as! RecommendedCollectionViewCell
              
        cell.artistLabel.text = recommendation.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
