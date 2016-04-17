//
//  SegmentViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class SegmentViewController: UIViewController {

    /* Segment Controller */
    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    /* Segment Control Containers */
    @IBOutlet weak var inProgressContainer: UIView!
    @IBOutlet weak var completeContainer: UIView!
    @IBOutlet weak var favoriteContainer: UIView!
    
    /* Segment Control View Controllers */
    var inprogressViewController : InProgressViewController?
    var completeViewController : CompleteViewController?
    var favoriteViewController : FavoriteViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeView(sender: AnyObject) {
        setSelectedView()
    }

    // Show the container view for the one selected and hide the other one.
    func setSelectedView() {
        if (SegmentControl.selectedSegmentIndex == 0) {
            inProgressContainer.hidden = true;
            completeContainer.hidden = true;
            favoriteContainer.hidden = false;
        }
        else if (SegmentControl.selectedSegmentIndex == 1)
        {
            inProgressContainer.hidden = true;
            completeContainer.hidden = false;
            favoriteContainer.hidden = true;
        }
        
        else {
            inProgressContainer.hidden = false;
            completeContainer.hidden = true;
            favoriteContainer.hidden = true;
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
