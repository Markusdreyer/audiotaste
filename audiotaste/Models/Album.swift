//
//  Album.swift
//  audiotaste
//
//  Created by Markus Dreyer on 22/10/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

struct Album: Codable {
    var album: [AlbumData]!
}

struct MostLoved: Codable {
    var loved: [AlbumData]!
}

struct AlbumData: Codable {
    var idAlbum : String?
    var idArtist : String?
    var idLabel : String?
    var intLoved : String?
    var intSales : String?
    var intScore : String?
    var intScoreVotes : String?
    var intYearReleased : String?
    var strAlbum : String?
    var strAlbumStripped : String?
    var strAlbumThumb : String?
    var strArtist : String?
    var strDescriptionEN : String?
}

