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
        
        //Add gesture from hide keyboard when the user touch the screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
    }

    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: - Keyboard management
    func hideKeyboard(){
        self.view.endEditing(true)
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
        
        pickerController.delegate = self
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





extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            memeImage.contentMode = .ScaleAspectFit
            
            memeImage.image = self.imageWithSize(chosenImage, size: CGSize(width: 120, height: 120))
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            memeImage.contentMode = .ScaleAspectFit
            
            memeImage.image = self.imageWithSize(chosenImage, size: CGSize(width: 120, height: 120))
            dismissViewControllerAnimated(true, completion: nil)
            
        }
        
    }
    
    func imageWithSize(image: UIImage,size: CGSize)->UIImage{
        if UIScreen.mainScreen().respondsToSelector("scale"){
            UIGraphicsBeginImageContextWithOptions(size,false,UIScreen.mainScreen().scale);
        }
        else{
            UIGraphicsBeginImageContext(size);
        }
        
        image.drawInRect(CGRectMake(0, 0, size.width, size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
    
}

