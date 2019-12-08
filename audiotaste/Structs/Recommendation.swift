//
//  Recommendation.swift
//  audiotaste
//
//  Created by Markus Dreyer on 08/12/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//

import Foundation

struct Recommendation: Codable {
    let similar: Similar

    enum CodingKeys: String, CodingKey {
        case similar = "Similar"
    }
}

struct Similar: Codable {
    let info, results: [Info]

    enum CodingKeys: String, CodingKey {
        case info = "Info"
        case results = "Results"
    }
}

struct Info: Codable {
    let name: String
    let type: TypeEnum

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case type = "Type"
    }
}

enum TypeEnum: String, Codable {
    case music = "music"
}
