//
//  Photo+CoreDataProperties.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/29/16.
//  Copyright © 2016 GroupB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Photo {

    @NSManaged var photo: NSData?
    @NSManaged var project: Project?

}
