//
//  SearchViewController.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchInput: UITextField!
    var request = APIRequest()
    var albumData: [AlbumData] = []
    var segueData: AlbumData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchInput.addTarget(self, action: #selector(SearchViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.searchInput.delegate = self
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func textFieldDidChange(_ textField: UITextField) {
        performSearch()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.dismissKeyboard()
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
           return 100
       }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return albumData.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let album = albumData[indexPath.row]
        
        self.segueData = album
        performSegue(withIdentifier: "detailViewSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let album = albumData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "toplistTableViewCell", for: indexPath) as! TableViewCell
        
        if album.strAlbumThumb != nil {
            let imageUrl = URL(string: album.strAlbumThumb!)
            cell.tableAlbumImageView.kf.setImage(with: imageUrl)
        }
       
        cell.tableAlbumLabel.text = album.strAlbumStripped
        cell.tableArtistLabel.text = album.strArtist
        return cell
    }
    
    func performSearch() {
        let parsedInput = searchInput.text?.replacingOccurrences(of: " ", with: "+")
        albumData = []
        request.fetch(requestUrl: "https://theaudiodb.com/api/v1/json/1/searchalbum.php?a=\(parsedInput!)", completion: { (response) in
            let decoder = JSONDecoder.init()
            let albumSearchResponse = try! decoder.decode(Album.self, from: response!)
            if albumSearchResponse.album != nil {
                for album in albumSearchResponse.album {
                    self.albumData.append(album)
                }
            }
                
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailViewController = segue.destination as! DetailViewController
         detailViewController.albumData = segueData
    }
}
