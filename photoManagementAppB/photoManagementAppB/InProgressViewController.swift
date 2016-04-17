//
//  inProgressViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class InProgressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var projects = [NSManagedObject]()

    @IBOutlet weak var inProgressTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inProgressTable.delegate = self
        inProgressTable.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        loadProject()
        inProgressTable.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func loadProject()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Project")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                projects = results
            }
            else {
                print("Could not fetch array")
            }
        } catch {
            return
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        let title = projects[indexPath.row].valueForKey("projectName") as? String
        cell.textLabel?.text = title
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("Here")
            projects.removeAtIndex(indexPath.row)
            inProgressTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let markRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Mark as Complete", handler:{action, indexpath in
            print("Mark•ACTION");
        });
        markRowAction.backgroundColor = UIColor.blueColor();
        
        let favoriteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Favorite", handler:{action, indexpath in
            print("Favorite•ACTION")
        });
        
        favoriteRowAction.backgroundColor = UIColor.orangeColor()
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Delete", handler:{action, indexpath in
            print("DELETE•ACTION")
            //self.test.removeAtIndex(indexPath.row)
            self.saveDeletedProject(indexPath.row)
            self.inProgressTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        });
        
        return [deleteRowAction, markRowAction, favoriteRowAction];
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if let newProjectViewController = destinationViewController as? NewProjectViewController {
            if (segue.identifier == "project")
            {
                newProjectViewController.newProject = projects[inProgressTable.indexPathForSelectedRow!.row]
            }
        }
    }
    
    func saveDeletedProject(index: Int)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let project = projects[index]
        projects.removeAtIndex(index)
        managedContext.deleteObject(project)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not create new project")
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
