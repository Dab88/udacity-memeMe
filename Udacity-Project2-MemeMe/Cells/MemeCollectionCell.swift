//
//  MemeCollectionCell.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 11/30/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class MemeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var memeImage: UIImageView!
    
    class var identifier: String { return String.className(self) }
    
    func setup(meme: Meme){
    
        //Set cell.memeImage with meme.memeImage
        self.memeImage.image =  meme.memeImage
       
    }
}
