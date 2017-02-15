//
//  MultiSelectImageVC.swift
//  MultiSelectImage2
//
//  Created by DW02 on 2/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

import Photos
import PhotosUI


class MultiSelectImageVC: UIViewController {

 
    
    
    var screenSize:CGRect = UIScreen.main.bounds
    
    
    @IBOutlet weak var viTopBarBG_Layout_Top: NSLayoutConstraint!

    
    @IBOutlet weak var viTopBarBG: UIView!
    
    @IBOutlet weak var btCancel: UIButton!
    
    @IBOutlet weak var btDone: UIButton!
    
    let imagePicker = UIImagePickerController()
    
    var myCollection: UICollectionView!
    var customLayout:UICollectionViewFlowLayout!
    
    
    var haveNoti:Bool = false
    
    var coolection_OriginY:CGFloat = 64
    let cellMinWidth:CGFloat = 100
    var cellSize:CGSize = CGSize(width: 100, height: 100)
    
    
    // MARK: Properties
    var allPhotos: PHFetchResult<PHAsset>!
  
    var selectAtIndex:[NSInteger:NSInteger] = [NSInteger:NSInteger]()
    
    var imageCamera:UIImage? = nil
    
    
    var callBack:([UIImage])->Void = {(arImage) in }
    
    
    var arSelectImage:[UIImage] = [UIImage]()
    var countFinishLoad:NSInteger = 0
    
    var working:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.clipsToBounds = true
        self.navigationController?.isNavigationBarHidden = true
        
        self.imageCamera = UIImage(named: "camera-icon.png")
        
        // Create a PHFetchResult object for each section in the table view.
        let allPhotosOptions = PHFetchOptions()
        allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        allPhotos = PHAsset.fetchAssets(with: allPhotosOptions)
    
        
        PHPhotoLibrary.shared().register(self)
        
        
        
        PHPhotoLibrary.requestAuthorization { (status) in
            
            if status == .authorized {
                print("authorized")
                
                
                PHPhotoLibrary.shared().register(self)
                
                
                
            }else{
                
            }
            
        }
        
        
        
        
        
        
        
        if(self.customLayout == nil){
            self.customLayout = UICollectionViewFlowLayout()
            self.customLayout.minimumLineSpacing = 4
            self.customLayout.minimumInteritemSpacing = 4
        }
        
        
        
        let cw:CGFloat = self.bestFitButtonSizeInCell(minWidth: cellMinWidth)
        self.cellSize = CGSize(width: cw, height: cw)
        self.customLayout.itemSize = self.cellSize
        self.customLayout.scrollDirection = .vertical
        
        
        if(self.myCollection == nil){
            self.myCollection = UICollectionView(frame: CGRect(x:0, y:coolection_OriginY, width:screenSize.width, height:screenSize.height - coolection_OriginY), collectionViewLayout: self.customLayout)
            self.view.addSubview(self.myCollection)
            self.myCollection.backgroundColor = UIColor.clear
            self.myCollection.contentInset.left = 4
            self.myCollection.contentInset.right = 4
            
            let nib1:UINib = UINib(nibName: "MultiSelectImageCollectionCell", bundle: nil)
            
            self.myCollection.register(nib1, forCellWithReuseIdentifier: "MultiSelectImageCollectionCell")
            //self.myCollection.register(nib1, forCellReuseIdentifier: "PopularCollectionViewCell")
        }
        
        
        
        self.myCollection.delegate = self
        self.myCollection.dataSource = self
        
        self.btDone.isEnabled = false
        
        self.imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
    override func viewWillAppear(_ animated: Bool) {
        self.updateFrame()
        
        if(haveNoti == false){
            haveNoti = true
            //NotificationCenter.default.addObserver(self, selector: #selector(MultiSelectImageVC.orientationChanged(notification:)), name:NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged(notification:)), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
        
        
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.updateFrame()
        
        
        
        
        
        /*
        
        let seconds = 1.450
        let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            let index0:IndexPath = IndexPath(item: 0, section: 0)
            
            self.myCollection.reloadItems(at: [index0])
        }*/
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if(haveNoti == true){
            haveNoti = false
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)//removeObserver(self, name: name:UIDeviceOrientationDidChangeNotification, object: nil)
            
            
            
        }
    }
    
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - RotageView
    func orientationChanged(notification:NSNotification){
        self.adjustViewsForOrientation(orientation: UIApplication.shared.statusBarOrientation, Animate: false)
    }
    
    func adjustViewsForOrientation(orientation:UIInterfaceOrientation, Animate animate:Bool){
        
        
        
        switch(orientation){
        case .portrait, .portraitUpsideDown:
            break
            
            
        case .landscapeLeft, .landscapeRight:
            break
        default:
            break
            
        }
        
        screenSize = UIScreen.main.bounds
        updateFrame()
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            // It's an iPhone
            break
        case .pad:
            // It's an iPad
            
            
            let seconds = 0.20
            
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.updateFrame()
            }
            
            
            
            break
        case .unspecified:
            // Uh, oh! What could it be?
            break
        default:
            break
        }
    }
    
    
    func updateFrame() {
        
        self.screenSize = UIScreen.main.bounds
        
        
        if(self.screenSize.height > self.screenSize.width){
            self.coolection_OriginY = 64
            
            self.viTopBarBG_Layout_Top.constant = 20
        }else{
            self.coolection_OriginY = 44
            self.viTopBarBG_Layout_Top.constant = 0
        }
        
        
        
        let cw:CGFloat = self.bestFitButtonSizeInCell(minWidth: cellMinWidth)
        
        
        
        
        self.cellSize = CGSize(width: cw, height: cw)
        self.customLayout.itemSize = self.cellSize
        self.myCollection.frame = CGRect(x:0, y:coolection_OriginY, width:self.screenSize.width, height:self.screenSize.height - coolection_OriginY)
        self.myCollection.reloadData()
      
    }
    
    
    
    
    
    // MARK: - Action
    
    
    @IBAction func tapOnCancel(_ sender: UIButton) {
        
        self.exitScene()
    }
    
    @IBAction func tapOnDone(_ sender: UIButton) {
        
        
        
        
        self.getImageSelected()
        
        
        
        
       
    }
    
    
    
    func exitScene()  {
        if let navigation = self.navigationController{
            navigation.dismiss(animated: true) {
                
            }
        }else{
            self.dismiss(animated: true) {
                
            }
        }
    }
    
    
    
    // MARK: - Function Helper
    
    func bestFitButtonSizeInCell(minWidth:CGFloat)->CGFloat {
        screenSize = UIScreen.main.bounds
        let cellW = self.screenSize.width - 8
        
        let countBT:NSInteger = NSInteger(cellW / minWidth)
        let space:CGFloat = CGFloat(countBT - 1) * 4
        
        
        let btW = (cellW - space) / CGFloat(countBT)
        return btW
    }
    
    
    
    func getImageSelected() {
        
        self.countFinishLoad = 0
        self.arSelectImage.removeAll()
        self.view.isUserInteractionEnabled = false
        
        let arSortKey = self.selectAtIndex.sorted { (obj1, obj2) -> Bool in
            let value1 = obj1.value
            let value2 = obj2.value
            
            return value1 < value2
        }
        
        
        
        for item in arSortKey{
            let imageIndex:NSInteger = item.key - 1
            
            if((imageIndex >= 0) && (imageIndex < self.allPhotos.count)){
                
                let asset = self.allPhotos[imageIndex]
                    
                
                /*
                let tSize:CGSize = CGSize(width: CGFloat(asset.pixelWidth), height: CGFloat(asset.pixelHeight))
                
                
                PHImageManager.default().requestImage(for: asset, targetSize: tSize, contentMode: PHImageContentMode.aspectFit, options: nil, resultHandler: { image, _ in
                    
                    if let image = image{
                        self.arSelectImage.append(image)
                    }
                    
                    self.finishLoadImage()
                })*/
                
                
                PHImageManager.default().requestImageData(for: asset, options: nil, resultHandler: { (imageData, _, _, _) in
                    if let imageData = imageData{
                        let image = UIImage(data: imageData)
                        if let image = image{
                            self.arSelectImage.append(image)
                        }
                    }
                    
                    self.finishLoadImage()
                })
                
                
                
            }
        }
        
        
        
        
    }
    
    
    
    
    
    
    func finishLoadImage() {
        self.countFinishLoad += 1
        if(self.countFinishLoad >= self.selectAtIndex.count){
            
            if(self.working == false){
                self.working = true
                self.callBack(self.arSelectImage)
                self.exitScene()
            }
            
            
        }
    }
}





// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension MultiSelectImageVC:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotos.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MultiSelectImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiSelectImageCollectionCell", for: indexPath) as! MultiSelectImageCollectionCell
        
        cell.updateCellSize(size: self.cellSize)
        
        if(indexPath.row > 0){
            cell.asset = self.allPhotos[indexPath.row - 1]
            
            
            let activeNumber:NSInteger? = self.selectAtIndex[indexPath.row]
            if let activeNumber = activeNumber{
                
                cell.setActiveCellWith(selectNumber: activeNumber)
                
            }else{
                cell.setActiveCellWith(selectNumber: 0)
            }
            
            cell.thumbnailImage.contentMode = .scaleAspectFill
        }else{
            //Camera
            cell.setActiveCellWith(selectNumber: 0)
            
            
            if let image = self.imageCamera{
                cell.thumbnailImage.image = image
                cell.thumbnailImage.alpha = 1
                cell.viBaackground.alpha = 1
            }
            
            cell.thumbnailImage.contentMode = .center
        }
        
    
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    
        if(indexPath.row > 0){
            
            
           
            let activeNumber:NSInteger? = self.selectAtIndex[indexPath.row]
            if let activeNumber = activeNumber{
                if(activeNumber <= 0){
                    
                    
                    self.addActiveCellAtIndex(indexPath: indexPath)
                }else{
                    self.removeActiveCellAtIndex(indexPath: indexPath)
                }
                
            }else{
                self.addActiveCellAtIndex(indexPath: indexPath)
            }
            
            
            collectionView.deselectItem(at: indexPath, animated: true)
            
            
            
            
        }else{
            //Camera
            
            self.imagePicker.allowsEditing = false
            self.imagePicker.sourceType = .camera
            
            self.present(self.imagePicker, animated: true) {
                
            }
            
        }
        
        
        
    }
    
    
    
    func addActiveCellAtIndex(indexPath: IndexPath) {
        
        let cell:MultiSelectImageCollectionCell? = myCollection.cellForItem(at: indexPath) as? MultiSelectImageCollectionCell
        if let cell = cell{
            
            
            var countActive:NSInteger = 1
            
            for item in self.selectAtIndex{
                if(item.value > 0){
                    countActive += 1
                }
            }
            
            self.selectAtIndex[indexPath.row] = countActive
            cell.number = countActive
            cell.animateButton()
            //cell.setActiveCellWith(selectNumber: countActive)
            self.btDone.isEnabled = true
        }
    }
    
    
    func removeActiveCellAtIndex(indexPath: IndexPath) {
        
        
        var arIndex:[IndexPath] = [IndexPath]()
        let removeNumber:NSInteger? = self.selectAtIndex[indexPath.row]
        
        let cell:MultiSelectImageCollectionCell? = myCollection.cellForItem(at: indexPath) as? MultiSelectImageCollectionCell
        if let cell = cell{
            cell.number = 0
            cell.animateButton()
            //cell.setActiveCellWith(selectNumber: 0)
        }
        
        
        if let removeNumber = removeNumber{
            
            self.selectAtIndex.removeValue(forKey: indexPath.row)
            
            
            for item in self.selectAtIndex{
                if((item.value > 0) && (item.value > removeNumber)){
                    let lase = item.value
                    
                    self.selectAtIndex[item.key] = lase - 1
                  
                    let index:IndexPath = IndexPath(item: item.key, section: 0)
                    arIndex.append(index)
                }
            }
            
            
            
            self.myCollection.reloadItems(at: arIndex)
            
        }
        
        
        if(arIndex.count > 0){
            self.btDone.isEnabled = true
        }else{
            self.btDone.isEnabled = false
        }
        
        
        
    }
    
}




// MARK: PHPhotoLibraryChangeObserver
extension MultiSelectImageVC: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        // Change notifications may be made on a background queue. Re-dispatch to the
        // main queue before acting on the change as we'll be updating the UI.
        DispatchQueue.main.sync {
            // Check each of the three top-level fetches for changes.
            
            if let changeDetails = changeInstance.changeDetails(for: allPhotos) {
                // Update the cached fetch result.
                allPhotos = changeDetails.fetchResultAfterChanges
                // (The table row for this one doesn't need updating, it always says "All Photos".)
                
                
                self.myCollection.reloadData()
            }
            
           
            
        }
    }
}



// MARK: - UIImagePickerControllerDelegate
extension MultiSelectImageVC:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        if pickedImage != nil {
      

           
            var arImage:[UIImage] = [UIImage]()
            arImage.append(pickedImage!)
            self.callBack(arImage)
            
            self.view.isUserInteractionEnabled = false
            
            let seconds = 0.450
            
            
            let when = DispatchTime.now() + seconds // change 2 to desired number of seconds
            DispatchQueue.main.asyncAfter(deadline: when) {
                // Your code with delay
                self.exitScene()
            }
            
            
        }
        
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.imagePicker.dismiss(animated: true) {
            
        }
    }
    
}

