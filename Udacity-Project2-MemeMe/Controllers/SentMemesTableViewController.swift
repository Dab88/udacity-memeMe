//
//  SentMemesTableViewController.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 11/24/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UIViewController {

    @IBOutlet weak var memeTableView: UITableView!
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewWillAppear(animated: Bool) {
        memeTableView.reloadData()
    }
}


extension SentMemesTableViewController : UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(MemeTableViewCell.identifier, forIndexPath: indexPath) as! MemeTableViewCell
        
        //Set cell with meme values
        cell.setup(memes[indexPath.row])
        
        return cell
        
    }
    
}

extension SentMemesTableViewController: UITableViewDelegate{

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        detailController.meme = memes[indexPath.row]
        
        navigationController!.pushViewController(detailController, animated: true)
        
    }
}