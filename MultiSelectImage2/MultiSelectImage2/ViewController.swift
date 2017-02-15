//
//  ViewController.swift
//  MultiSelectImage2
//
//  Created by DW02 on 2/15/2560 BE.
//  Copyright © 2560 DW02. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    var arImageSelect:[UIImage] = [UIImage]()
    
    
    @IBOutlet weak var sampleCollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.sampleCollection.delegate = self
        self.sampleCollection.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func tapOnAddImage(_ sender: UIButton) {
        
        self.showImagePicker()
        
    }
    

    
    func showImagePicker() {
        let album:MultiSelectImageVC = MultiSelectImageVC(nibName: "MultiSelectImageVC", bundle: nil)
        album.callBack = {(images) in
            
            
            self.arImageSelect.removeAll()
            
            self.arImageSelect+=images
            
            self.sampleCollection.reloadData()
        }
        let navigation:UINavigationController = UINavigationController(rootViewController: album)
        
        self.present(navigation, animated: true) {
            
        }
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate


extension ViewController:UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arImageSelect.count + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell:MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
 
        
        if(indexPath.row > 0){
   
            cell.lbTitle.alpha = 0.0
            cell.myImage.alpha = 1.0
            
            cell.myImage.image = self.arImageSelect[indexPath.row - 1]
            
        }else{
           
            
            cell.lbTitle.alpha = 1.0
            cell.myImage.alpha = 0.0
        }
        
        
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if(indexPath.row > 0){
            
            
          
            
            
        }else{
          
    
            self.showImagePicker()
            
        }
        
        
        
    }
    
    
    
    
}
