//
//  Favorite.swift
//  audiotaste
//
//  Created by Markus Dreyer on 04/12/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

import Foundation

struct Track: Codable {
    var track: [TrackData]!
}

struct TrackData: Codable, Hashable {
    var strTrack : String!
    var intDuration : String!
    var strArtist: String!
}

struct Favorite: Codable {
    var artist: String
}
