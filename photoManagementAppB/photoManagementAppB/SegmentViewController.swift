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
    var inprogressViewController : inProgressViewController?
    var completeViewController : CompleteViewController?
    var favoriteViewController : FavoriteViewController?
    
    /* Array Lists to store Project Data (In Progress, Complete, and Favorite) */
    var inProgressProjects: NSManagedObject?
    
    var name = "Test" as AnyObject
    var pdescription = "This is a test" as AnyObject
    var keywords = "Test1" as AnyObject
    var status = false as AnyObject
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let inProgressProjects = inProgressProjects {
            name = inProgressProjects.valueForKey("projectName")!
            pdescription = inProgressProjects.valueForKey("projectDescription")!
            keywords = inProgressProjects.valueForKey("projectKeywords")!
            status = inProgressProjects.valueForKey("projectFavorited")!
        }
        
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
            saveProject()
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
    
    func saveProject()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if inProgressProjects == nil {
            let arrayEntity = NSEntityDescription.entityForName("Project", inManagedObjectContext: managedContext)
            inProgressProjects = NSManagedObject(entity: arrayEntity!, insertIntoManagedObjectContext: managedContext)
        }
        
        inProgressProjects?.setValue(name, forKey: "projectName")
        inProgressProjects?.setValue(pdescription, forKey: "projectDescription")
        inProgressProjects?.setValue(keywords, forKey: "projectKeywords")
        inProgressProjects?.setValue(status, forKey: "projectFavorited")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
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
