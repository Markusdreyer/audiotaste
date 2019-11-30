//
//  Track.swift
//  audiotaste
//
//  Created by Markus Dreyer on 30/11/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

struct Track: Codable {
    var track: [TrackData]!
}

struct TrackData: Codable {
    var strTrack : String!
    var intDuration : String!
}

