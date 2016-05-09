//
//  NewPhotoViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 5/1/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData
import Social
import MessageUI

class NewPhotoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoNameField: UITextField!
    @IBOutlet weak var photoCaptionField: UITextField!
    @IBOutlet weak var photoKeywordsField: UITextField!
    @IBOutlet weak var photoLocationField: UITextField!
    @IBOutlet weak var photoPhotographerField: UITextField!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var flagPhoto: UIBarButtonItem!
    
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
            if editPhoto.valueForKey("photoFlagged") as? Bool == true {
                print("Photo is flagged!")
                flagPhoto.tintColor = UIColor.orangeColor()
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action:#selector(NewPhotoViewController.imageTapped(_:)))
        
        imageView.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = self.view.frame
        newImageView.backgroundColor = .blackColor()
        newImageView.contentMode = .ScaleAspectFit
        newImageView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(NewPhotoViewController.dismissFullscreenImage(_:)))
        newImageView.addGestureRecognizer(tap)
        
        self.view.addSubview(newImageView)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func dismissFullscreenImage(sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func savePhoto(sender: AnyObject) {
        savePhoto()
    }
    
    @IBAction func sharePhoto(sender: AnyObject) {
        sharePhoto()
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
    
    func sharePhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let sharePhoto = UIAlertAction(title: "Facebook", style: .Default) { (action) in self.shareOnFacebook()  }
        alert.addAction(sharePhoto)
        let tweetPhoto = UIAlertAction(title: "Twitter", style: .Default) { (action) in self.shareOnTwitter() }
        alert.addAction(tweetPhoto)
        let mailPhoto = UIAlertAction(title: "Email", style: .Default) { (action) in self.shareOnMail()  }
        alert.addAction(mailPhoto)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func shareOnMail() {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        let photoName = photo?.valueForKey("photoName") as? String
        let captionOfPhoto = photo?.valueForKey("photoCaption") as? String
        
        mailComposerVC.setToRecipients(["gakf38@mail.missouri.edu"])
        if photoName != nil && captionOfPhoto != nil {
            mailComposerVC.setSubject(photoName!)
            mailComposerVC.setMessageBody(captionOfPhoto!, isHTML: false)
            mailComposerVC.addAttachmentData(photo?.valueForKey("photo") as! NSData, mimeType: "image/jpeg", fileName: photoName!)
        }
        else {
            mailComposerVC.addAttachmentData(photo?.valueForKey("photo") as! NSData, mimeType: "image/jpeg", fileName: "Photo Taxi Photo")
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
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            let facebookSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            let photoName = photo?.valueForKey("photoName") as? String
            let captionOfPhoto = photo?.valueForKey("photoCaption") as? String
            if photoName != nil && captionOfPhoto != nil {
                facebookSheet.setInitialText(photoName! + ":\n" + captionOfPhoto!)
            }
            let imageToDisplay: UIImage! = UIImage(data: photo?.valueForKey("photo") as! NSData)
            facebookSheet.addImage(imageToDisplay)
            self.presentViewController(facebookSheet, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func shareOnTwitter() {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            let twitterSheet:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            let photoName = photo?.valueForKey("photoName") as? String
            let captionOfPhoto = photo?.valueForKey("photoCaption") as? String
            if photoName != nil && captionOfPhoto != nil {
                twitterSheet.setInitialText(photoName! + ": " + captionOfPhoto!)
            }
            let imageToDisplay: UIImage! = UIImage(data: photo?.valueForKey("photo") as! NSData)
            twitterSheet.addImage(imageToDisplay)
            
            self.presentViewController(twitterSheet, animated: true, completion: nil)
            
        } else {
            
            let alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func flagPhoto(sender: AnyObject) {
        if photo?.valueForKey("photoFlagged") as? Bool == true {
            photo?.setValue(false, forKey: "photoFlagged")
            print("photo unflagged")
            flagPhoto.tintColor = nil
        } else {
            photo?.setValue(true, forKey: "photoFlagged")
            print("photo flagged")
            flagPhoto.tintColor = UIColor.orangeColor()
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
