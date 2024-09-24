//
//  Landmark+CoreDataProperties.swift
//  LandMarks
//
//  Created by Timis Petre Leon on 24.09.2024.
//
//

import Foundation
import CoreData


extension Landmark {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Landmark> {
        return NSFetchRequest<Landmark>(entityName: "Landmark")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var park: String?
    @NSManaged public var state: String?
    @NSManaged public var landmarkDescription: String?
    @NSManaged public var isFeatured: Bool
    @NSManaged public var isFavorite: Bool

}

extension Landmark : Identifiable {

}
