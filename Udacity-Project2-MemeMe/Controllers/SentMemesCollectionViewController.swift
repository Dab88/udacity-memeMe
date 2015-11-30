//
//  SentMemesCollectionViewController.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 11/24/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.collectionView?.reloadData()
        
    }
    
    
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MemeCollectionCell.identifier, forIndexPath: indexPath) as! MemeCollectionCell
      
        //Set cell with meme values
        cell.setup(memes[indexPath.row])
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        
      //  let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("VillainDetailViewController") as! VillainDetailViewController
        
        //detailController.villain = self.allVillains[indexPath.row]
        //self.navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}