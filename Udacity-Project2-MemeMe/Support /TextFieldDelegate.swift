//
//  TextFieldDelegate.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 10/18/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    
    func textFieldDidBeginEditing(textField: UITextField){
        
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        
        return true
    }
    
}
