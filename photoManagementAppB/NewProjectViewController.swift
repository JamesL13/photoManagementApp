//
//  NewProjectViewController.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class NewProjectViewController: UIViewController {

    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectKeywordField: UITextField!
    @IBOutlet weak var projectDescriptionField: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var newProject: NSManagedObject?
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.toolBar.hidden = true
        let borderColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        projectDescriptionField.layer.borderColor = borderColor.CGColor
        projectDescriptionField.layer.borderWidth = 0.5
        projectDescriptionField.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
        if let editProject = newProject {
            projectNameField.text = editProject.valueForKey("projectName") as? String
            projectKeywordField.text = editProject.valueForKey("projectKeywords") as? String
            projectDescriptionField.text = editProject.valueForKey("projectDescription") as? String
            self.toolBar.hidden = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveNewProject()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        if newProject == nil {
            let newProjectEntity = NSEntityDescription.entityForName("Project", inManagedObjectContext: managedContext)
            newProject = NSManagedObject(entity: newProjectEntity!, insertIntoManagedObjectContext: managedContext)
            newProject?.setValue(false, forKey: "projectFavorited")
        }
        
        newProject?.setValue(projectNameField.text, forKey: "projectName")
        newProject?.setValue(projectKeywordField.text, forKey: "projectKeywords")
        newProject?.setValue(projectDescriptionField.text, forKey: "projectDescription")
        if (newProject?.valueForKey("projectFavorited"))! as! NSObject == true {
            newProject?.setValue(true, forKey: "projectFavorited")
        } else {
            newProject?.setValue(true, forKey: "projectFavorited")
        }
        //newProject?.setValue(false, forKey: "projectFavorited")
        newProject?.setValue(false, forKey: "projectCompleted")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not create new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* Saves the new project */
    @IBAction func saveButton(sender: AnyObject) {
        saveNewProject()
    }
    
    @IBAction func deleteProject(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(newProject!)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func favoriteProject(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (newProject?.valueForKey("projectFavorited"))! as! NSObject == true {
            newProject?.setValue(false, forKey: "projectFavorited")
        } else {
            newProject?.setValue(true, forKey: "projectFavorited")
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save favorited project")
            print("Could not save \(error), \(error.userInfo)")
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
