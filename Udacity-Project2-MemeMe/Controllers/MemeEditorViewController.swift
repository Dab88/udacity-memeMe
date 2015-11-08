//
//  MemeEditorViewController.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 10/3/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

/**
Meme Editor View

The Meme Editor View consists of an image view overlaid by two text fields, one near the top and one near the bottom of the image. This view has a bottom toolbar with two buttons: one for the camera and one for the photo album. The top navigation bar has a share button on the left displaying Apple’s stock share icon and a “Cancel” button on the right.
*/


class MemeEditorViewController: UIViewController {

    
    @IBOutlet weak var topMessageTxtField: UITextField!
    @IBOutlet weak var bottomMessageTxtField: UITextField!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTextFieldAttributes()
        subscribeToKeyboardNotifications()
        
        // Do any additional setup after loading the view.
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func keyboardWillShow(notification: NSNotification){
    
        self.view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
 
    func keyboardWillHide(notification: NSNotification){
        
        self.view.frame.origin.y += getKeyboardHeight(notification)
    }
    
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
    
        let userInfo = notification.userInfo
       
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
    
        return keyboardSize.CGRectValue().height
        
    }
    
    func subscribeToKeyboardNotifications(){
    
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
         NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func unsubscribeFromKeyboardNotifications(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    
    
    func setTextFieldAttributes(){
        
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0 //For fill the text.
        ]
        
        
        topMessageTxtField.defaultTextAttributes = memeTextAttributes
        bottomMessageTxtField.defaultTextAttributes = memeTextAttributes
        
        topMessageTxtField.textAlignment = NSTextAlignment.Center
        bottomMessageTxtField.textAlignment = NSTextAlignment.Center
        
    }
    
    func save() {
        //Create the meme
        //let meme = Meme( text: textField.text!, image:
            //memeImage.image, memedImage: memedImage)
    }

    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
