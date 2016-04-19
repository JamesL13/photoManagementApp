//
//  Project.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/15/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import Foundation
import CoreData

@objc(Project)
class Project: NSManagedObject {
    // Insert code here to add functionality to your managed object subclass
    static let CLASS_NAME = NSStringFromClass(Project).componentsSeparatedByString(".").last!
    
    static let PROJECT_DESCRIPTION = "projectDescription"
    static let PROJECT_FAVORITED = "projectFavorited"
    static let PROJECT_COMPLETED = "projectCompleted"
    static let PROJECT_KEYWORDS = "projectKeywords"
    static let PROJECT_NAME = "projectName"
}
