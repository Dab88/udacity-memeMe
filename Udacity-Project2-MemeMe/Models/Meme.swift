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
    var memeImageView: UIImageView!
    
    required init(topString: String, bottomString: String, image: UIImage) {
        super.init()
        
        self.topString = topString
        self.bottomString = bottomString
        self.originalImage = image
    }
    
    func generateMemedImage() -> UIImage{
        
       // self.navigationController?.navigationBarHidden = false
        
        // TODO: Hide toolbar and navbar
        
        UIGraphicsBeginImageContext(memeImageView.frame.size)
        
        memeImageView.drawViewHierarchyInRect(memeImageView.frame,
            afterScreenUpdates: true)
        
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
           // TODO:  Show toolbar and navbar 
        
        return memedImage
    }
}
