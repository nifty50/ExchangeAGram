//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Ansel Adams on 2/21/16.
//  Copyright © 2016 Ansel Adams. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var feedArray: [AnyObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        let request = NSFetchRequest(entityName: "FeedItem")
        let appDelegate: AppDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        let context: NSManagedObjectContext = appDelegate.managedObjectContext
        do {
            feedArray = try context.executeFetchRequest(request)
        } catch {
            abort()
        }
        collectionView.reloadData()
        print(feedArray)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func profileTapped(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("profileSegue", sender: nil)
    }
    
    @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            let mediaTypes: [AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes as! [String]
            cameraController.allowsEditing = false
            self.presentViewController(cameraController, animated: true, completion: nil)
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let photoLibraryContoller = UIImagePickerController()
            photoLibraryContoller.delegate = self
            photoLibraryContoller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            let mediaTypes: [AnyObject] = [kUTTypeImage]
            photoLibraryContoller.mediaTypes = mediaTypes as! [String]
            photoLibraryContoller.editing = false
            self.presentViewController(photoLibraryContoller, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Alert", message: "Your device doesn't support camera or photo library.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerContollerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        let thumbnailData = UIImageJPEGRepresentation(image, 0.1)
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext)
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext)
        
        feedItem.image = imageData
        feedItem.caption = "test caption"
        feedItem.thumbnail = thumbnailData
        
        (UIApplication.sharedApplication().delegate as! AppDelegate).saveContext()
        
        feedArray.append(feedItem)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.collectionView.reloadData()
    }
    
    // UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! FeedCell
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        cell.imageView.image = UIImage(data: thisItem.image!)
        cell.captionLabel.text = thisItem.caption
        
        return cell
    }
    
    // UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let thisItem = feedArray[indexPath.row] as! FeedItem
        
        let filterVC = FilterViewController()
        filterVC.thisFeedItem = thisItem
        self.navigationController?.pushViewController(filterVC, animated: false)
    }

}
