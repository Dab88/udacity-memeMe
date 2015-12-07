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
    
    var memeIndex: Int!
    var meme:Meme!

    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }

    
    @IBOutlet weak var memeImageDetail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNavItemOnView()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        meme = memes[memeIndex]
        memeImageDetail.image = meme.memeImage
        tabBarController?.tabBar.hidden = false
    }
    
    //MARK: - NavigationBar Methods
    func addNavItemOnView(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
    }
    
    func editMeme(){
        
        let memeEditorController = storyboard!.instantiateViewControllerWithIdentifier("MemeEditorViewController") as! MemeEditorViewController
        
        memeEditorController.previousMeme = meme
        memeEditorController.memeIndex = memeIndex
        
        navigationController!.pushViewController(memeEditorController, animated: true)
        
    }
}