//
//  SelectPhotosViewController.swift
//  photoManagementAppB
//
//  Created by Garrett Knox on 5/9/16.
//  Copyright © 2016 GroupB. All rights reserved.
//

import UIKit
import CoreData

class SelectPhotosViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var selectPhotoCollection: UICollectionView!
    
    var photo = [NSManagedObject]()
    var selectedPhotos = [NSManagedObject]()
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    /* Apply/Remove Border to Cell and Append/Remove Photo object to selectedPhotos Array */
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell!.layer.borderColor = UIColor.blueColor().CGColor
        
        if cell!.layer.borderWidth == 3.0 {
            selectedPhotos.removeAtIndex(selectedPhotos.indexOf(photo[indexPath.item])!)
            cell!.layer.borderWidth = 0.0
        }
        else {
            selectedPhotos.append(photo[indexPath.item])
            cell!.layer.borderWidth = 3.0
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("selectphotocell", forIndexPath: indexPath)
        
        if photo.count > 0 {
            let imageView = cell.viewWithTag(1) as! UIImageView
            let imageToDisplay: UIImage! = UIImage(data: photo[indexPath.item].valueForKey("photo") as! NSData)
            imageView.image = imageToDisplay
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
    
    
    @IBAction func deleteSelectedPhotos(sender: AnyObject) {
        
        if selectedPhotos.count > 0 {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let deletePhoto = UIAlertAction(title: "Delete", style: .Destructive) { (action) in self.deletePhotos() }
            alert.addAction(deletePhoto)
            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            print("No photos selected")
        }
    }
    
    func deletePhotos() {
        
        print("Photos to delete: \(selectedPhotos.count)")
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        for index in 0...(selectedPhotos.count - 1) {
            let deleteIndex = photo.indexOf(selectedPhotos[index])
            managedContext.deleteObject(photo[deleteIndex!])
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save new project")
            print("Could not save \(error), \(error.userInfo)")
        }
        
        self.navigationController?.popViewControllerAnimated(true)
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
