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

struct AlbumData: Codable {
    var idAlbum : String!
    var idArtist : String!
    var idLabel : String!
    var intLoved : String!
    var intSales : String!
    var intScore : String!
    var intScoreVotes : String!
    var intYearReleased : String!
    var strAlbum : String!
    var strAlbum3DCase : String!
    var strAlbumCDart : String!
    var strAlbumSpine : String!
    var strAlbumStripped : String!
    var strAlbumThumb : String!
    var strAlbumThumbBack : String!
    var strAllMusicID : String!
    var strArtist : String!
    var strArtistStripped : String!
    var strBBCReviewID : String!
    var strDescription : String!
    var strDescriptionPT : String!
    var strDiscogsID : String!
    var strGenre : String!
    var strLabel : String!
    var strLocked : String!
    var strMood : String!
    var strMusicBrainzArtistID : String!
    var strMusicBrainzID : String!
    var strRateYourMusicID : String!
    var strReleaseFormat : String!
    var strReview : String!
    var strSpeed : String!
    var strStyle : String!
    var strWikidataID : String!
    var strWikipediaID : String!
}

