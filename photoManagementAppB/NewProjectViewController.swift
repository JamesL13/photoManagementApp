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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let borderColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        projectDescriptionField.layer.borderColor = borderColor.CGColor
        projectDescriptionField.layer.borderWidth = 0.5
        projectDescriptionField.layer.cornerRadius = 5.0
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveNewProject()
    {
        /* Function that saves the new project to the appropriate Project array */
    }
    
    func createProjectData()
    {
        /* Function that creates a new Project based on the user info in the UI Elements */
    }
    
    /* Saves the new project */
    @IBAction func saveButton(sender: AnyObject) {
        saveNewProject()
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
