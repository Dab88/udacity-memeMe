//
//  StringExtension.swift
//  Udacity-Project2-MemeMe
//
//  Created by Daniela Velasquez on 11/30/15.
//  Copyright © 2015 Mahisoft. All rights reserved.
//

import Foundation

extension String {
  
    static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).componentsSeparatedByString(".").last!
    }

}