//
//  Project+CoreDataProperties.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/15/16.
//  Copyright © 2016 GroupB. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Project {

    @NSManaged var projectDescription: String!
    @NSManaged var projectFavorited: NSNumber!
    @NSManaged var projectCompleted: NSNumber!
    @NSManaged var projectKeywords: String!
    @NSManaged var projectName: String!

}
