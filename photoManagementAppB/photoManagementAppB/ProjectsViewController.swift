//
//  SegmentViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class ProjectsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, ProjectsHeaderViewDelegate {

    static let CELL_IDENTIFIER = "ProjectCell"
    var projects = [NSManagedObject]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }
    }
    
    
    var headerView = ProjectsHeaderView()
    
    let managedObjectContext = AppDelegate.getInstance().managedObjectContext
    
    

    var fetchedResultsController: NSFetchedResultsController?
    
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerView.delegate = self
        
        // Setup the Search Controller
        self.searchController.searchResultsUpdater = self
        self.definesPresentationContext = true
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.tableView.tableHeaderView = searchController.searchBar
        
        let height = self.tableView.tableHeaderView!.frame.height
        self.tableView.setContentOffset(CGPointMake(0, height), animated: false)
        
        self.invalidateFetchedResultsController()
    }
    
    func invalidateFetchedResultsController() {
        let fetchRequest = NSFetchRequest(entityName: Project.CLASS_NAME)
        
        let sortDescriptor = NSSortDescriptor(key: Project.PROJECT_NAME, ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        var predicate:NSPredicate!
        switch self.headerView.selectedIndex {
        case 0: // Active
            let query = Project.PROJECT_COMPLETED + " == %@"
            predicate = NSPredicate(format: query, false)
        case 1: // Complete
            let query = Project.PROJECT_COMPLETED + " == %@"
            predicate = NSPredicate(format: query, true)
        case 2:// Favorites
            let query = Project.PROJECT_FAVORITED + " == %@"
            predicate = NSPredicate(format: query, true)
        default:
            print("Undefined Case")
            abort()
        }
        
        if let text = self.searchController.searchBar.text where !text.isEmpty {
            var query = Project.PROJECT_NAME + " CONTAINS[cd] %@"
            let searchNamePredicate = NSPredicate(format: query, text)
            
            query = Project.PROJECT_DESCRIPTION + " CONTAINS[cd] %@"
            let searchDescriptionPredicate = NSPredicate(format: query, text)
            
            query = Project.PROJECT_KEYWORDS + " CONTAINS[cd] %@"
            let searchKeywordsPredicate = NSPredicate(format: query, text)
            
            let predicates = [searchNamePredicate, searchDescriptionPredicate, searchKeywordsPredicate]
            
            predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSCompoundPredicate(orPredicateWithSubpredicates: predicates)])
        }
        
        fetchRequest.predicate = predicate

        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        // Configure Fetched Results Controller
        self.fetchedResultsController!.delegate = self
        
        do {
            try self.fetchedResultsController!.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
            abort()
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData()
    }
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController?.sections!.first!.numberOfObjects ?? 0
    }
    
    // MARK: UITablieViewDelegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(ProjectsViewController.CELL_IDENTIFIER, forIndexPath: indexPath)
        let project = self.fetchedResultsController!.objectAtIndexPath(indexPath) as! Project
        
        cell.textLabel!.text = project.projectName
        cell.detailTextLabel!.text = project.projectKeywords
        
        
        //TODO: set up image
        cell.imageView!.image = nil
        
        //TODO: show tags
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.invalidateFetchedResultsController()
    }
    
    // MARK: - ProjectsHeaderViewDelegate
    func projectsHeaderView(projectsHeaderView: ProjectsHeaderView,
                            seletedIndexDidChange index: Int) {
        self.invalidateFetchedResultsController()
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destinationViewController = segue.destinationViewController
        
        if let newProjectViewController = destinationViewController as? NewProjectViewController {
            if (segue.identifier == "project")
            {
                newProjectViewController.newProject = self.fetchedResultsController?.fetchedObjects![tableView.indexPathForSelectedRow!.row] as! Project
                newProjectViewController.fetchedResultsController = self.fetchedResultsController
            }
        }
    
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            print("Here")
            projects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let markRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Completed", handler:{action, indexpath in
            print("Completed•ACTION");
            self.saveCompletedProject(indexPath)
        });
        markRowAction.backgroundColor = UIColor.blueColor();
        
        let favoriteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Favorite", handler:{action, indexpath in
            print("Favorite•ACTION")
            self.saveFavoritedProject(indexPath)
        });
        
        favoriteRowAction.backgroundColor = UIColor.orangeColor()
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "Remove", handler:{action, indexpath in
            print("DELETE•ACTION")
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let deleteProject = UIAlertAction(title: "Delete", style: .Destructive) { (action) in self.saveDeletedProject(indexPath) }
            alert.addAction(deleteProject)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        });
        
        return [deleteRowAction, markRowAction, favoriteRowAction];
    }
    
    func saveDeletedProject(index: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(self.fetchedResultsController?.objectAtIndexPath(index) as! NSManagedObject)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func saveFavoritedProject(index: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if (self.fetchedResultsController?.fetchedObjects![index.row].valueForKey("projectFavorited"))! as! NSObject == true {
            self.fetchedResultsController?.fetchedObjects![index.row].setValue(false, forKey: "projectFavorited")
        } else {
            self.fetchedResultsController?.fetchedObjects![index.row].setValue(true, forKey: "projectFavorited")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save favorited project")
            print("Could not save \(error), \(error.userInfo)")
        }
        //self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func saveCompletedProject(index: NSIndexPath)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        if (self.fetchedResultsController?.fetchedObjects![index.row].valueForKey("projectCompleted"))! as! NSObject == true {
            self.fetchedResultsController?.fetchedObjects![index.row].setValue(false, forKey: "projectCompleted")
        } else {
            self.fetchedResultsController?.fetchedObjects![index.row].setValue(true, forKey: "projectCompleted")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save completed project")
            print("Could not save \(error), \(error.userInfo)")
        }
        //self.navigationController?.popToRootViewControllerAnimated(true)
    }
}
