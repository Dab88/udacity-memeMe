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
    
    //MARK: UI
    @IBOutlet weak var topMessageTxtField: UITextField!
    @IBOutlet weak var bottomMessageTxtField: UITextField!
    @IBOutlet weak var originalImage: UIImageView!
    @IBOutlet weak var cameraBtn: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    //Previous meme information
    var previousMeme: Meme?
    var memeIndex: Int!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setTextFieldAttributes()
        
        //Add gesture from hide keyboard when the user touch the screen
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        //Enable the cameraBtn only if camera is available
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        navigationController?.navigationBarHidden = false
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        //Enable the cameraBtn only if camera is available
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
        //Load previous meme, if apply
        reloadPreviousMeme()
        
        tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        previousMeme = nil
        unsubscribeFromKeyboardNotifications()
    }
    
    
    // MARK: - Keyboard management Methods
    func hideKeyboard(){
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification){
        if(bottomMessageTxtField.isFirstResponder()){
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        view.frame.origin.y = 0
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
    
    
    // MARK: - IBActions Methods
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func takePhotoFromCamera(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.sourceType = .Camera
        pickerController.modalPresentationStyle = .FullScreen
        pickerController.cameraCaptureMode = .Photo
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(sender: AnyObject) {
        originalState()
        navigationController?.dismissViewControllerAnimated(true, completion: nil)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
       
        //Save meme
        let meme = save()
        
        //Share the meme
        guard (meme != nil) else{
            let alert = UIAlertController(title: "",
                message: "Select an image to share", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            
            alert.addAction(dismissAction)
            
            presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        share(meme:meme!)
    }
    
    
    //MARK: - Other Methods
    
    /**
    * Set textfield attributes
    */
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
    
    /**
     * Make the meme object and call share function
     */
    func save() -> Meme?{
        
        //Create the meme
        if let originalImage = originalImage.image {
            let meme = Meme( topString: topMessageTxtField.text!, bottomString: bottomMessageTxtField.text!, originalImage: originalImage, memeImage: generateMemedImage())
            
        
            guard previousMeme != nil else{
                //Add it to the memes array
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
                return meme
            }
            
            //Update meme
            (UIApplication.sharedApplication().delegate as! AppDelegate).updateMemeAtIndex(memeIndex, meme: meme)
            
            return meme
            
        }
        
        return nil
    }
    
    /**
     * Generate the meme image with the textfields values
     */
    func generateMemedImage() -> UIImage{
        
        //Hide the toolbar for that no appearing in the meme image
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //Show the toolbar again
        toolbar.hidden = false
        
        return memedImage
    }
    
    /**
     * Share meme image with the device options
     */
    func share(meme meme: Meme){
        
        let objectsToShare = [meme.memeImage]
        
        let shareActivityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        shareActivityVC.completionWithItemsHandler = {(activityType: String?, bool: Bool, dictType: [AnyObject]?, error: NSError?) -> Void in
            //Back to previous viewController
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.popViewControllerAnimated(true)
        }
        
        presentViewController(shareActivityVC, animated: true, completion: nil)
        
    }
    
    func originalState(){
        originalImage.image = UIImage()
        topMessageTxtField.text = "TOP"
        bottomMessageTxtField.text = "BOTTOM"
    }
    
    /**
     * Load previous meme if the meme is different to nil.
     * previousMeme var has been filled at MemeDetailViewController
     */
    func reloadPreviousMeme(){
        guard previousMeme != nil else{
            return
        }
        
        topMessageTxtField.text = previousMeme?.topString
        bottomMessageTxtField.text = previousMeme?.bottomString
        originalImage.image = previousMeme?.originalImage
    }
}





extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            originalImage.contentMode = .ScaleAspectFit
            
            originalImage.image = imageWithSize(chosenImage, size: CGSize(width: originalImage.frame.width, height: originalImage.frame.height))
     
            
            dismissViewControllerAnimated(true, completion: nil)
            
        }else if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            originalImage.contentMode = .ScaleAspectFit
            
            originalImage.image = imageWithSize(chosenImage, size: CGSize(width: originalImage.frame.width, height: originalImage.frame.height))
       
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
    
    
    func resizeImageWithAspect(image: UIImage,scaledToMaxWidth width:CGFloat,maxHeight height :CGFloat)->UIImage{
        let oldWidth = image.size.width;
        let oldHeight = image.size.height;
        
        let scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
        
        let newHeight = oldHeight * scaleFactor;
        let newWidth = oldWidth * scaleFactor;
        let newSize = CGSizeMake(newWidth, newHeight);
        
        return imageWithSize(image, size: newSize);
    }
    
}

extension MemeEditorViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

