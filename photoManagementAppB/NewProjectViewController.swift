//
//  NewProjectViewController.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class NewProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectKeywordField: UITextField!
    @IBOutlet weak var projectDescriptionField: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    
    var newProject: NSManagedObject?
    
    //var imageList = [String]()
    var imageList = [UIImage]()
    
    var photo = [NSManagedObject]()
    var newPhoto: NSManagedObject?
    
    
    var fetchedResultsController: NSFetchedResultsController?
    
    let imagePicker = UIImagePickerController()
    
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
        
        /*for index in 0...(3) {
            imageList.append("Photo\(index).jpg")
        }*/
        
        if (loadPhoto()) {
            if (photo.count > 0) {
                print("There are photos in core data to display")
                for index in 0...(photo.count - 1) {
                    let imageToDisplay: UIImage! = UIImage(data: photo[index].valueForKey("photo") as! NSData)
                    imageList.append(imageToDisplay)
                }
            }
        }
        
        //loadPhoto()
        
        imagePicker.delegate = self
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
        print("DELETE•ACTION")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let deleteProject = UIAlertAction(title: "Delete", style: .Destructive) { (action) in self.saveDeletedProject(sender) }
        alert.addAction(deleteProject)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func saveDeletedProject(sender: AnyObject) {
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
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photocell", forIndexPath: indexPath)
        if imageList.count > 0 {
            let imageView = cell.viewWithTag(1) as! UIImageView
            imageView.image = imageList[indexPath.item]
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //selectedImageView.image = UIImage(named: imageList[indexPath.item])
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        let supplementaryView: UICollectionReusableView
        
        if kind == UICollectionElementKindSectionHeader {
            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "header", forIndexPath: indexPath)
        } else {
            supplementaryView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "footer", forIndexPath: indexPath)
        }
        
        return supplementaryView
    }
    
    

    @IBAction func addPhoto(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
        
        /*Add the selected pictures to the projects corresponding array*/
        
        /*Save array to core data*/
    }
    
    /* Function that saves a photo to core data */
    func savePhoto(pickedImage: UIImage)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if newPhoto == nil {
            let newPhotoEntity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedContext)
            newPhoto = NSManagedObject(entity: newPhotoEntity!, insertIntoManagedObjectContext: managedContext)
        }
        
        let imageData: NSData! = UIImagePNGRepresentation(pickedImage)
        
        newPhoto?.setValue(imageData, forKey: "photo")
        
        do {
            try managedContext.save()
            print("Save Successful")
        } catch let error as NSError {
            print("Could not save the photo")
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            savePhoto(pickedImage)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /* Function that Loads the project photo data */
    func loadPhoto() -> Bool
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName:"Photo")
        
        do {
            let fetchedResults = try managedContext.executeFetchRequest(fetchRequest) as? [NSManagedObject]
            
            if let results = fetchedResults {
                photo = results
                return true
            }
            else {
                print("Could not fetch array")
                return false
            }
        } catch {
            return false
        }
    }
    
    
}
