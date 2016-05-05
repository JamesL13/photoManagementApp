//
//  NewPhotoViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 5/1/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class NewPhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoNameField: UITextField!
    @IBOutlet weak var photoCaptionField: UITextField!
    @IBOutlet weak var photoKeywordsField: UITextField!
    @IBOutlet weak var photoLocationField: UITextField!
    @IBOutlet weak var photoPhotographerField: UITextField!
    
    var photo: Photo?
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let editPhoto = photo {
            self.navigationItem.title = editPhoto.valueForKey("photoName") as? String
            imageView.image = UIImage(data: editPhoto.valueForKey("photo") as! NSData)
            photoNameField.text = editPhoto.valueForKey("photoName") as? String
            photoCaptionField.text = editPhoto.valueForKey("photoCaption") as? String
            photoKeywordsField.text = editPhoto.valueForKey("photoKeywords") as? String
            photoLocationField.text = editPhoto.valueForKey("photoLocation") as? String
            photoPhotographerField.text = editPhoto.valueForKey("photoPhotographer") as? String
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePhoto(sender: AnyObject) {
        savePhoto()
    }
    
    @IBAction func deletePhoto(sender: AnyObject) {
        print("DELETE•ACTION")
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let deletePhoto = UIAlertAction(title: "Delete", style: .Destructive) { (action) in self.deletePhoto() }
        alert.addAction(deletePhoto)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /* Function that saves a photo to core data */
    func savePhoto()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

        photo?.setValue(photoNameField.text, forKey: "photoName")
        photo?.setValue(photoCaptionField.text, forKey: "photoCaption")
        photo?.setValue(photoKeywordsField.text, forKey: "photoKeywords")
        photo?.setValue(photoLocationField.text, forKey: "photoLocation")
        photo?.setValue(photoPhotographerField.text, forKey: "photoPhotographer")
        
        do {
            try managedContext.save()
            print("Save Successful")
        } catch let error as NSError {
            print("Could not save the photo")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func deletePhoto()
    {
        print("Delete this photo!")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        managedContext.deleteObject(self.photo!)
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func flagPhoto(sender: AnyObject) {
        if photo?.valueForKey("photoFlagged") as? Bool == true {
            photo?.setValue(false, forKey: "photoFlagged")
            print("photo unflagged")
        } else {
            photo?.setValue(true, forKey: "photoFlagged")
            print("photo flagged")
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
