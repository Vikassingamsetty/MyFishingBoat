//
//  CardView.swift
//  HCC
//
//  Created by Appcare on 29/01/20.
//  Copyright © 2020 Appcare. All rights reserved.
//

import UIKit

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 1
    

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)

        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = .zero
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }

}


@IBDesignable class CardViewss: UIView {
    
    @IBInspectable var cornerRadius:CGFloat = 0.0
    @IBInspectable var ofSetWidth:CGFloat = 5.0
    @IBInspectable var ofSetHeight:CGFloat = 5.0
    var ofSetShadowOpacity:Float = 1.0
    @IBInspectable var color:UIColor = UIColor.black
    
    override func layoutSubviews() {
        layer.cornerRadius = self.cornerRadius
        layer.shadowColor = color.cgColor
        layer.shadowOffset = CGSize(width: ofSetWidth, height: ofSetHeight)
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: self.cornerRadius).cgPath
        layer.shadowOpacity = self.ofSetShadowOpacity
    }
    
    
}

