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
        tabBarController?.tabBar.hidden = false
        collectionView?.reloadData()
        
    }
    
    
    
    // MARK: Collection View Data Source
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MemeCollectionCell.identifier, forIndexPath: indexPath) as! MemeCollectionCell
      
        //Set cell with meme values
        cell.setup(memes[indexPath.row])
        
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath){
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = memes[indexPath.row]
        
         navigationController!.pushViewController(detailController, animated: true)
        
    }
    
}