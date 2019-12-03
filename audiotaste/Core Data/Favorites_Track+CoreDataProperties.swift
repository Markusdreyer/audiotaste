//
//  Favorites_Track+CoreDataProperties.swift
//  audiotaste
//
//  Created by Markus Dreyer on 03/12/2019.
//  Copyright © 2019 Markus Dreyer. All rights reserved.
//
//

import Foundation
import CoreData


extension Favorites_Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorites_Track> {
        return NSFetchRequest<Favorites_Track>(entityName: "Favorites_Track")
    }

    @NSManaged public var intDuration: String?
    @NSManaged public var strArtist: String?
    @NSManaged public var strTrack: String?

}
