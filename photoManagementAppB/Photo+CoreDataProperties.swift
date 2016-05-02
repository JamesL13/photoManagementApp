//
//  Photo+CoreDataProperties.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 5/1/16.
//  Copyright © 2016 GroupB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var photo: NSData?
    @NSManaged var photoName: String?
    @NSManaged var photoLocation: String?
    @NSManaged var photoPhotographer: String?
    @NSManaged var photoCaption: String?
    @NSManaged var photoKeywords: String?
    @NSManaged var project: Project?

}
