//
//  CustomButton.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 27/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius>0
        }
    }
    
//    @IBInspectable var borderWidth:CGFloat = 0 {
//        didSet {
//            layer.borderWidth = borderWidth
//        }
//    }
    
    @IBInspectable var borderColor:UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity:Float = 0 {
        didSet{
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowRadius:CGFloat = 0 {
        didSet{
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor:UIColor? {
        didSet{
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowWidth:CGFloat = 0{
        
        didSet {
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            layer.shadowOpacity = shadowOpacity
            layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
        
    }
    @IBInspectable var shadowHeight:CGFloat = 0{
        
        didSet {
            layer.shadowColor = shadowColor?.cgColor
            layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
            layer.shadowOpacity = shadowOpacity
            layer.masksToBounds = false
            layer.shadowRadius = shadowRadius
        }
    }
    
}
