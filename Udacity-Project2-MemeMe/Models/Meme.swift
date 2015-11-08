//
//  Meme.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 10/18/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class Meme : NSObject{
    
    var topString: String!
    var bottomString: String!
    var originalImage: UIImage!
    var memeImage: UIImage! //Combining the text and the original image
    
    required init(topString: String, bottomString: String, original: UIImage, memeImage: UIImage) {
        
        super.init()
        
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = original
        self.memeImage = memeImage
    }
    
}
