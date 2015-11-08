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
    
    var currentTextField: UITextField!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setTextFieldAttributes()
        
        //Add gesture from hide keyboard when the user touch the screen
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "hideKeyboard"))
        
        //Enable the cameraBtn only if camera is available
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        
        //Enable the cameraBtn only if camera is available
        cameraBtn.enabled = UIImagePickerController.isSourceTypeAvailable(.Camera)
        
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
        if( currentTextField == bottomMessageTxtField){
            self.view.frame.origin.y -= getKeyboardHeight(notification)
            
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification){
        if( currentTextField == bottomMessageTxtField){
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
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
    
    
    // MARK: - IBActions
    @IBAction func pickAnImage(sender: AnyObject) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
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
        
    }
    
    
    @IBAction func shareMeme(sender: AnyObject) {
        save()
    }
    
    
    //MARK: - Other
    
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
    func save() {
        
        //Create the meme
        let meme = Meme( topString: topMessageTxtField.text!, bottomString: bottomMessageTxtField.text!, original: originalImage.image!, memeImage: generateMemedImage())
        
        //Share the meme
        share(meme:meme)
    }
    
    /**
     * Generate the meme image with the textfields values
     */
    func generateMemedImage() -> UIImage{
        
        //Hide the toolbar for that no appearing in the meme image
        toolbar.hidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame,
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
        
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
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
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            originalImage.image = chosenImage
            dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
}

extension MemeEditorViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
        currentTextField = textField
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

