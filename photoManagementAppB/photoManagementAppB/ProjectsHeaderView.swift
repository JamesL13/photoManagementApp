//
//  ProjectsHeaderView.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/15/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit

protocol ProjectsHeaderViewDelegate: class {
    func projectsHeaderView(projectsHeaderView:ProjectsHeaderView, seletedIndexDidChange index:Int)
}

class ProjectsHeaderView : NibDesignable {
    @IBOutlet weak var segmentedControl:UISegmentedControl!
    weak var delegate:ProjectsHeaderViewDelegate?
    
    var selectedIndex:Int {
        return self.segmentedControl.selectedSegmentIndex
    }
    
    @IBAction func segmentedControlSelectedIndexDidChange(sender:AnyObject) {
        self.delegate?.projectsHeaderView(self, seletedIndexDidChange: self.segmentedControl.selectedSegmentIndex)
    }
}