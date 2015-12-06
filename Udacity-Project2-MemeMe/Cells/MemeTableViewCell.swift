//
//  MemeTableViewCell.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 11/30/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImage: UIImageView!
    @IBOutlet weak var memetext: UILabel!
    
    class var identifier: String { return String.className(self) }

    func setup(meme: Meme){
        
        //Set cell.memeImage with meme.memeImage
        memeImage.image = meme.memeImage
        
        //Set name
        memetext.text = meme.topString + " " + meme.bottomString
    }
}
