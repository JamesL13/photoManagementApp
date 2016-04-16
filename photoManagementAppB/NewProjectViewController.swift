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

    /* Text Fields and Views of the View Controller */
    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectKeywordField: UITextField!
    @IBOutlet weak var projectDescriptionField: UITextView!
    
    /* Collection View of the View Controller */
    @IBOutlet weak var projectPhotos: UICollectionView!
    
    /* Current project pulled from core data */
    var project: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Set the border of the text view to match the text fields */
        let borderColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        projectDescriptionField.layer.borderColor = borderColor.CGColor
        projectDescriptionField.layer.borderWidth = 0.5
        projectDescriptionField.layer.cornerRadius = 5.0
        /* Displays the information of a pre-existing project */
        if let editProject = project {
            projectNameField.text = editProject.valueForKey("projectName") as? String
            projectKeywordField.text = editProject.valueForKey("projectKeywords") as? String
            projectDescriptionField.text = editProject.valueForKey("projectDescription") as? String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Function that save the new/updated project into core data */
    func saveProject()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        /* Check for if project is nil (new project being created) */
        if project == nil {
            let newProjectEntity = NSEntityDescription.entityForName("Project", inManagedObjectContext: managedContext)
            project = NSManagedObject(entity: newProjectEntity!, insertIntoManagedObjectContext: managedContext)
        }
        
        project?.setValue(projectNameField.text, forKey: "projectName")
        project?.setValue(projectKeywordField.text, forKey: "projectKeywords")
        project?.setValue(projectDescriptionField.text, forKey: "projectDescription")
        project?.setValue(false, forKey: "projectFavorited")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not create new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        /* Return to previous navigation location upon creation/edit of project */
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* Saves the new project */
    @IBAction func saveButton(sender: AnyObject) {
        saveProject()
    }
    
    /* Adds Photos to the project */
    @IBAction func addPhotos(sender: AnyObject) {
        /* Open native camera roll to select pictures (UIImagePicker) */
        /* Add the selected pictures to the projects corresponding array */
        /* Save the array to Core Data?? */
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
