//
//  Helpers.swift
//  UserListApp
//
//  Created by Mesrop Kareyan on 10/5/17.
//  Copyright © 2017 mesrop. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func color(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: 1.0)
    }
    
    static var appBlue: UIColor {
        return color(red: 102, green: 154, blue: 174)
    }
    
    static var appLightBlue: UIColor {
        return color(red: 102, green: 154, blue: 240)
    }
}
