#####Storyboard Updates
1. change Collection View cell size to 150/150
2. Delete ViewController and replace with new FeedViewControllerClass
  -- change class in MainStoryboard view controller
3. Wire the Collection View to FeedViewController.swift (outlet: collectionView)

#####UICollectionViewDataSource
1. add protocols to FeedViewController class declaration
2. Wire collectionView to FeedViewController as datasource & delegate
3. Add numberOfSectionsInCollectionView func to FeedViewController
   -- also add collectionView:numberOfItemsInSection & collectionView:cellForItemAtIndexPath

#####FeedCell
1. Create FeedCell class inherits from UICollectionViewCell
2. Add ReuseIdentifier to Collection View Cell
3. Make sure collectionViewCell's class is FeedCell in storyboard
4. Add ImageView & label to cell
  -- label color: white, fontsize: 12
5. Wire ImageView & label to FeedCell.swift (imageView, captionLabel)

#####CameraController
1. Wire camera to FeedViewController.swift (action, snapBarButtonItemTapped, type: UIBarButtonItem)
2. add MobileCoreServices Framework to project, then import MobileCoreServices to FeedViewController.swift
3. if camera is available, setup up cameracontroller, else imagepickercontroller
  -- add UIImagePickerControllerDelegate and UINavigationControllerDelegate to FeedViewController at the top
  ```swift
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
        }
  ```

#####Photo Library
1. If the photoLibrary is available, set it up
2. set up alert if nothing is available
```swift
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
```

#####didFinishPickingImage
1. implement imagePickerController(didFinishPickingMediaWithInfo)
```swift
  // UIImagePickerControllerDelegate
  func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
      
      // grab the image
      let image = info[UIImagePickerControllerOriginalImage] as UIImage
      
      // dismiss the imagePicker
      self.dismissViewControllerAnimated(true, completion: nil)
      
  }
```

#####Creating A FeedItem
1. change entity name to FeedItem
2. add attributes to ExchangeAGram data model (caption: string, image, binaryData)
3. editor/createNSManagedObjectSubclass....
4. add '@objc (FeedItem)' to FeedItem.swift for obj c integration

#####Persisting A FeedItem
1. convert UIImage to UIImageJPEGRepresentation (in V)
2. make sure CoreData is imported
add persistence to imagePickerControllerDelegate (didFinishPickingMediaWithInfo)
```swift
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
```

#####NSFetchRequest
1. make the request to originally populate the feedArray
```swift
class FeedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  @IBOutlet weak var collectionView: UICollectionView!
  
  var feedArray: [AnyObject] = []
  
  override func viewDidLoad() {
      super.viewDidLoad()

      // Do any additional setup after loading the view.
      
      let request = NSFetchRequest(entityName: "FeedItem")
      
      let appDelegate:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
      let context:NSManagedObjectContext = appDelegate.managedObjectContext!
      feedArray = context.executeFetchRequest(request, error: nil)!
      
  }
```

#####Displaying the FeedItem
1. fix the UICollectionViewDataSource functions
2. fix my mistake earlier (left non-existant outlet wired to camera... decouple it in storyboard)
3. make sure to append feedArray and refresh
4. put spacing around Collection View Cells (section insert) in Main Storyboard
```swift
// UICollectionViewDataASource
func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return feedArray.count
}

func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    var cell:FeedCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as FeedCell
    
    let thisItem = feedArray[indexPath.row] as FeedItem
    
    // populate the cell info
    cell.imageView.image = UIImage(data: thisItem.image)
    cell.captionLabel.text = thisItem.caption

    return cell
}
```

#####FilterViewController
1. create FilterViewController class -- inherits from UIViewController
2. add a property at the top of the new file: var thisFeedItem: FeedItem!

#####didSelectItemAtIndexPath
1. Add new collectionView function: didSelectItemAtIndexPath
```swift
func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
  let thisItem = feedArray[indexPath.row] as FeedItem
}
```

#####Presenting the FilterViewController
1. create the filterVC and push it onto the navigationController stack
```swift
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let thisItem = feedArray[indexPath.row] as FeedItem
        
        var filterVC = FilterViewController()
        filterVC.thisFeedItem = thisItem
        
        self.navigationController?.pushViewController(filterVC, animated: false)
    }
```

#####Begin Creating a UICollectionView
1. create the layout and collectionView in viewDidLoad() function
```swift
  // create the layout
  let layout = UICollectionViewFlowLayout()
  layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
  layout.itemSize = CGSize(width: 150.0, height: 150.0)
  
  // create the collectionView using the layout
  collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
  
  collectionView.dataSource = self
  collectionView.delegate = self
  
}
```
2. add UICollectionViewDataSource & UICollectionViewDelegate to FilterViewController
3. implement collectionView(numberOfItemsInSection) & collectionView(cellForItemAtIndexPath) stubs
```swift
  // UICollectionViewDataSource
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 1
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      return UICollectionViewCell()
  }
```
#####Finishing the UICollectionView
1. Add backgroundcolor to collectionView
2. display collectionView
```swift
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView)
        
    }
```
#####FilterCell
1. create FilterCell class - inherits from UICollectionViewCell
2. overide the initializer... create the imageView, display it
```swift
class FilterCell: UICollectionViewCell {
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
```

#####Implementing our FilterCell
1. set up the FilterCell class in FilterViewController/viewDidLoad()
```swift
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FilterCell.self, forCellWithReuseIdentifier: "MyCell")        
```
2. drag downloaded imageAssets into imageAsset folder
3. finish out collectionView/cellForRowAtIndexPath
```swift
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell:FilterCell = collectionView.dequeueReusableCellWithReuseIdentifier("MyCell", forIndexPath: indexPath) as FilterCell
        
        cell.imageView.image = UIImage(named: "Placeholder")
        
        return cell
    }
```
4. Somehow FilterCell class from last step got erased... redo it if necessary

#####PhotoFilters
1. add photoFilters() function to FilterViewController
```swift
    // Helper Function
    func photoFilters() -> [CIFilter] {
        
        let blur = CIFilter(name: "CIGaussianBlur")
        let instant = CIFilter(name: "CIPhotoEffectInstant")
        let noir = CIFilter(name: "CIPhotoEffectNoir")
        let transfer = CIFilter(name: "CIPhotoEffectTransfer")
        let unsharpen = CIFilter(name: "CIUnsharpMask")
        let monochrome = CIFilter(name: "CIColorMonochrome")
      
```

#####Properties of CIFilters
1. add kIntensity = 0.7 constant to top of file
2. add colorControls, sepia, and colorClamp
```swift
        let unsharpen = CIFilter(name: "CIUnsharpMask")
        let monochrome = CIFilter(name: "CIColorMonochrome")
        
        let colorControls = CIFilter(name: "CIColorControls")
        colorControls.setValue(0.5, forKey: kCIInputSaturationKey)
        
        let sepia = CIFilter(name: "CISepiaTone")
        sepia.setValue(kIntensity, forKey: kCIInputIntensityKey)
        
        let colorClamp = CIFilter(name: "CIColorClamp")
        colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
        colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
        
        return []
    }
```

#####Composite Filters
1. Continue adding filters
```swift
  let colorClamp = CIFilter(name: "CIColorClamp")
  colorClamp.setValue(CIVector(x: 0.9, y: 0.9, z: 0.9, w: 0.9), forKey: "inputMaxComponents")
  colorClamp.setValue(CIVector(x: 0.2, y: 0.2, z: 0.2, w: 0.2), forKey: "inputMinComponents")
  
  let composite = CIFilter(name: "CIHardLightBlendMode")
  composite.setValue(sepia.outputImage, forKey: kCIInputImageKey)
  
  let vignette = CIFilter(name: "CIVignette")
  vignette.setValue(composite.outputImage, forKey: kCIInputImageKey)
  vignette.setValue(kIntensity * 2, forKey: kCIInputIntensityKey)
  vignette.setValue(kIntensity * 30, forKey: kCIInputRadiusKey)

  return [blur, instant, noir, transfer, unsharpen, monochrome, colorControls, sepia, colorClamp, composite, vignette]
  ```

  ####Using the Filters
  1. 