//
//  NewProjectViewController.swift
//  photoManagementAppB
//
//  Created by MU IT Program on 4/7/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData
import Social
import MessageUI

class NewProjectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var projectNameField: UITextField!
    @IBOutlet weak var projectKeywordField: UITextField!
    @IBOutlet weak var projectDescriptionField: UITextView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var completeIcon: UIBarButtonItem!
    @IBOutlet weak var favoriteIcon: UIBarButtonItem!
    
    @IBOutlet weak var selectButton: UIBarButtonItem!
    
    var newProject: NSManagedObject?
    
    var imageList = [UIImage]()
    
    var photo = [NSManagedObject]()
    var newPhoto: NSManagedObject?
        
    var fetchedResultsController: NSFetchedResultsController?
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        projectNameField.returnKeyType = .Done
        projectNameField.delegate = self
        
        projectKeywordField.returnKeyType = .Done
        projectKeywordField.delegate = self
        
        projectDescriptionField.returnKeyType = .Done
        projectDescriptionField.delegate = self
        
        self.toolBar.hidden = true
        if(newProject == nil) {
            self.selectButton.enabled = false
        }
        else {
           self.selectButton.enabled = true
        }
        let borderColor = UIColor(red:204.0/255.0, green:204.0/255.0, blue:204.0/255.0, alpha:1.0)
        projectDescriptionField.layer.borderColor = borderColor.CGColor
        projectDescriptionField.layer.borderWidth = 0.5
        projectDescriptionField.layer.cornerRadius = 5.0
        
        // Do any additional setup after loading the view.
        if let editProject = newProject {
            self.navigationItem.title = editProject.valueForKey("projectName") as? String
            projectNameField.text = editProject.valueForKey("projectName") as? String
            projectKeywordField.text = editProject.valueForKey("projectKeywords") as? String
            projectDescriptionField.text = editProject.valueForKey("projectDescription") as? String
            self.toolBar.hidden = false
            //self.selectButton.enabled = true
            if ((newProject?.valueForKey("projectCompleted"))! as! NSObject == true) {
                completeIcon.tintColor = UIColor.orangeColor()
            }
            if ((newProject?.valueForKey("projectFavorited"))! as! NSObject == true) {
                favoriteIcon.tintColor = UIColor.orangeColor()
            }
            /* Disable/hide the Save button when the view is showing an existing project */
            /* Enable/show the Select button when the view is showing an existing project */
            
            if (loadPhoto()) {
                if (photo.count > 0) {
                    print("there are photos to display from core data")
                    print("There are photos in core data to display")
                    for index in 0...(photo.count - 1) {
                        if(photo[index].valueForKey("project") as? Project == editProject) {
                            let imageToDisplay: UIImage! = UIImage(data: photo[index].valueForKey("photo") as! NSData)
                            imageList.append(imageToDisplay)
                        }
                    }
                }
            }
        }
        
        imagePicker.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        self.photo = []
        self.imageList = []
        if newProject != nil {
            if (loadPhoto()) {
                if (photo.count > 0) {
                    print("there are photos to display from core data")
                    print("There are photos in core data to display")
                    for index in 0...(photo.count - 1) {
                        if(photo[index].valueForKey("project") as? Project == self.newProject) {
                            let imageToDisplay: UIImage! = UIImage(data: photo[index].valueForKey("photo") as! NSData)
                            imageList.append(imageToDisplay)
                        }
                    }
                }
            }
        }
        
        photoCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func saveNewProject()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        
        if newProject == nil {
            let newProjectEntity = NSEntityDescription.entityForName("Project", inManagedObjectContext: managedContext)
            newProject = NSManagedObject(entity: newProjectEntity!, insertIntoManagedObjectContext: managedContext)
            newProject?.setValue(false, forKey: "projectFavorited")
            newProject?.setValue(false, forKey: "projectCompleted")
        }
        
        newProject?.setValue(projectNameField.text, forKey: "projectName")
        newProject?.setValue(projectKeywordField.text, forKey: "projectKeywords")
        newProject?.setValue(projectDescriptionField.text, forKey: "projectDescription")
        /*if (newProject?.valueForKey("projectFavorited"))! as! NSObject == true {
            newProject?.setValue(true, forKey: "projectFavorited")
        } else {
            newProject?.setValue(true, forKey: "projectFavorited")
        }*/
        //newProject?.setValue(false, forKey: "projectCompleted")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not create new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    /* Saves the existing project on Navigation Back */
    override func didMoveToParentViewController(parent: UIViewController?) {
        if parent == nil {
            if projectNameField.text != ""  || projectKeywordField.text != "" {
                saveNewProject()
            }
        }
    }
    
    /* Saves the new project */
    /*@IBAction func saveButton(sender: AnyObject) {
        saveNewProject()
    }*/
    
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
            favoriteIcon.tintColor = nil
        } else {
            newProject?.setValue(true, forKey: "projectFavorited")
            favoriteIcon.tintColor = UIColor.orangeColor()
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save favorited project")
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func completeProject(sender: AnyObject) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        if (newProject?.valueForKey("projectCompleted"))! as! NSObject == true {
            newProject?.setValue(false, forKey: "projectCompleted")
            completeIcon.tintColor = nil
        } else {
            newProject?.setValue(true, forKey: "projectCompleted")
            completeIcon.tintColor = UIColor.orangeColor()
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save completed project")
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
        if photo[indexPath.item].valueForKey("photoFlagged") as? Bool == true {
            cell.layer.borderColor = UIColor.orangeColor().CGColor
            cell.layer.borderWidth = 1.0
        }
        else {
            cell.layer.borderColor = nil
            cell.layer.borderWidth = 0.0
        }
        
        return cell
    }
    
    /* Set the size of each cell to be 1/4 of the overall collectionview size */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width - 3)/4, height: (collectionView.frame.size.width - 3)/4)
    }
    
    /* Set the minimum spacing for left, right, top and bottom to 1.0 */
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1.0
    }

    @IBAction func addPhoto(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    /* Function that saves a photo to core data */
    func savePhoto(pickedImage: UIImage)
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

            let newPhotoEntity = NSEntityDescription.entityForName("Photo", inManagedObjectContext: managedContext)
            newPhoto = NSManagedObject(entity: newPhotoEntity!, insertIntoManagedObjectContext: managedContext)
        
        let imageData: NSData! = UIImageJPEGRepresentation(pickedImage, 1.0)
        
        newPhoto?.setValue(imageData, forKey: "photo")
        newPhoto?.setValue(self.newProject, forKey: "project")
        newPhoto?.setValue(false, forKey: "photoFlagged")
        
        do {
            try managedContext.save()
            print("Save Successful")
        } catch let error as NSError {
            print("Could not save the photo")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.photo = []
        self.imageList = []
        
        if (loadPhoto()) {
            if (photo.count > 0) {
                print("there are photos to display from core data")
                print("There are photos in core data to display")
                for index in 0...(photo.count - 1) {
                    if(photo[index].valueForKey("project") as? Project == self.newProject) {
                        let imageToDisplay: UIImage! = UIImage(data: photo[index].valueForKey("photo") as! NSData)
                        imageList.append(imageToDisplay)
                    }
                }
            }
        }

        photoCollectionView.reloadData()
        
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
                for result in results {
                    if result.valueForKey("project") as? Project == self.newProject && result.valueForKey("photoFlagged") as? Bool == true {
                        photo.append(result)
                    }
                }
                for result in results {
                    if result.valueForKey("project") as? Project == self.newProject && result.valueForKey("photoFlagged") as? Bool == false {
                        photo.append(result)
                    }
                }
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
    @IBAction func shareOnSocialMedia(sender: AnyObject) {
        print("SHARE•ACTION")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let shareProject = UIAlertAction(title: "Facebook", style: .Default) { (action) in self.shareOnFacebook()  }
        alert.addAction(shareProject)
        let mailProject = UIAlertAction(title: "Email", style: .Default) { (action) in self.shareOnMail()  }
        alert.addAction(mailProject)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func shareOnMail() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        let projectName = newProject?.valueForKey("projectName") as? String
        let descriptionOfProject = newProject?.valueForKey("projectDescription") as? String
        
        if(projectName != nil && descriptionOfProject != nil) {
        
            mailComposerVC.setSubject(projectName!)
            mailComposerVC.setMessageBody(descriptionOfProject!, isHTML: false)
        }
        
        for index in 0...(photo.count - 1) {
            if(photo[index].valueForKey("photoFlagged") as? Bool == true) {
                let imageToDisplay = photo[index].valueForKey("photo") as! NSData
                mailComposerVC.addAttachmentData(imageToDisplay, mimeType: "image/jpeg", fileName: projectName! + " Photo\(index)")
            }
        }
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposerVC, animated: true, completion: nil)
        } else {
            print("email failed")
        }
    }
    
    /* Function to close the Mail View Controller */
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func shareOnFacebook() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let projectName = newProject?.valueForKey("projectName") as? String
            let descriptionOfProject = newProject?.valueForKey("projectDescription") as? String
            if(projectName != nil && descriptionOfProject != nil) {
                facebookSheet.setInitialText(projectName! + ": " + descriptionOfProject!)
            }
            for index in 0...(photo.count - 1) {
                if(photo[index].valueForKey("photoFlagged") as? Bool == true) {
                    let imageToDisplay: UIImage! = UIImage(data: photo[index].valueForKey("photo") as! NSData)
                    facebookSheet.addImage(imageToDisplay)
                }
            }
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let destinationViewController = segue.destinationViewController
        
        if let newPhotoViewController = destinationViewController as? NewPhotoViewController {
            if (segue.identifier == "photoView")
            {
                /* Get the first object of the array returned because only a single image can be selected at a time */
                let path = photoCollectionView.indexPathsForSelectedItems()![0].item
                newPhotoViewController.photo = self.photo[path] as? Photo
                newPhotoViewController.fetchedResultsController = self.fetchedResultsController
            }
        }
        
        if let selectPhotosViewController = destinationViewController as? SelectPhotosViewController {
            if(segue.identifier == "selectPhotos")
            {
                selectPhotosViewController.photo = self.photo
                selectPhotosViewController.currentProject = self.newProject as? Project
                selectPhotosViewController.fetchedResultsController = self.fetchedResultsController
            }
        }
    }
    
    
}
