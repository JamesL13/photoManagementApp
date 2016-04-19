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
        cell.detailTextLabel!.text = project.projectDescription
        
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
        
    }
}
