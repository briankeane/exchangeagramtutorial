//
//  FeedViewController.swift
//  ExchangeAGram
//
//  Created by Brian D Keane on 3/28/15.
//  Copyright (c) 2015 Brian D Keane. All rights reserved.
//

import UIKit
import MobileCoreServices
import CoreData

class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
    
    @IBAction func snapBarButtonItemTapped(sender: UIBarButtonItem) {
        // if the camera is available
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            // set up the camera as the source type
            var cameraController = UIImagePickerController()
            cameraController.delegate = self
            cameraController.sourceType = UIImagePickerControllerSourceType.Camera
            
            // set up mediaTypes allowed by camera
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            cameraController.mediaTypes = mediaTypes
            
            cameraController.allowsEditing = false
            
            // present the camera controller on the screen
            self.presentViewController(cameraController, animated: true, completion: nil)
        
        // ELSE IF the PhotoLibrary is available, use that
        } else if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            // set it up
            var photoLibraryController = UIImagePickerController()
            photoLibraryController.delegate = self
            photoLibraryController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            // media types
            let mediaTypes:[AnyObject] = [kUTTypeImage]
            photoLibraryController.mediaTypes = mediaTypes
            
            photoLibraryController.allowsEditing = false
            
            self.presentViewController(photoLibraryController, animated: true, completion: nil)
        
        } else {
            // display a message that no picker is available
            var alertController = UIAlertController(title: "Alert", message:"Your device does not support the camera or photo Library", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    // UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        // grab the image
        let image = info[UIImagePickerControllerOriginalImage] as UIImage
        
        // convert UIImageInstance into NSData
        let imageData = UIImageJPEGRepresentation(image, 1.0)
        
        // persist it in CoreData
        let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
        let entityDescription = NSEntityDescription.entityForName("FeedItem", inManagedObjectContext: managedObjectContext!)
        
        // create the item and fill it with data
        let feedItem = FeedItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
        feedItem.image = imageData
        feedItem.caption = "test caption"
        
        // save the item
        (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
        
        
        // dismiss the imagePicker
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // UICollectionViewDataASource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
