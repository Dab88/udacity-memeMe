//
//  MemeDetailViewController.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 10/3/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit
/*

Meme Detail View

The Meme Detail View displays the selected meme in an image view in the center of the page with the meme’s original aspect ratio. The detail view has a back arrow in the top left corner. To the right of the arrow reads the title of the previous view, “Sent Memes.”

*/
class MemeDetailViewController: UIViewController {

    var meme:Meme!
    
    @IBOutlet weak var memeImageDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImageDetail.image = meme.memeImage
    }
}
