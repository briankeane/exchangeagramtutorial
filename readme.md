Storyboard Updates
1) change Collection View cell size to 150/150
2) Delete ViewController and replace with new FeedViewControllerClass
  -- change class in MainStoryboard view controller
3) Wire the Collection View to FeedViewController.swift (outlet: collectionView)

UICollectionViewDataSource
1) add protocols to FeedViewController class declaration
2) Wire collectionView to FeedViewController as datasource & delegate
3) Add numberOfSectionsInCollectionView func to FeedViewController
   -- also add collectionView:numberOfItemsInSection & collectionView:cellForItemAtIndexPath

FeedCell
1) Create FeedCell class inherits from UICollectionViewCell
2) Add ReuseIdentifier to Collection View Cell
3) Make sure collectionViewCell's class is FeedCell in storyboard
4) Add ImageView & label to cell
  -- label color: white, fontsize: 12
5) Wire ImageView & label to FeedCell.swift (imageView, captionLabel)

CameraController
1) Wire camera to FeedViewController.swift (action, snapBarButtonItemTapped, type: UIBarButtonItem)
2) add MobileCoreServices Framework to project, then import MobileCoreServices to FeedViewController.swift
3) if camera is available, setup up cameracontroller, else imagepickercontroller
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
  

