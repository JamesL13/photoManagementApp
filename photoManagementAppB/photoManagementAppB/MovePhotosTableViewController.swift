//
//  MovePhotosTableViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 5/10/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class MovePhotosTableViewController: UITableViewController {
    
    var selectedPhotos = [NSManagedObject]()
    
    var currentProject: Project?
    
    var projects = [NSManagedObject]()
    
    var fetchedResultsController: NSFetchedResultsController?

    override func viewDidLoad() {
        super.viewDidLoad()

        loadProjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return projects.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("projectcell", forIndexPath: indexPath)

        cell.textLabel?.text = projects[indexPath.item].valueForKey("projectName") as? String
        cell.detailTextLabel?.text = projects[indexPath.item].valueForKey("projectKeywords") as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        movePhotos((projects[indexPath.item] as? Project)!)
    }
    
    func loadProjects() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Project")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                
                for result in results {
                    if result as? Project != self.currentProject {
                        projects.append(result)
                    }
                }
                
            }
            else {
                
                print("Could not fetch array")
                
            }
        }
        catch {
            
        }
    }
    
    func movePhotos(moveTo: Project) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        for index in 0...(selectedPhotos.count - 1) {
            selectedPhotos[index].setValue(moveTo, forKey: "project")
        }
        
        do {
            try managedContext.save()
            print("Save Successful")
        } catch let error as NSError {
            print("Could not save the photo")
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
