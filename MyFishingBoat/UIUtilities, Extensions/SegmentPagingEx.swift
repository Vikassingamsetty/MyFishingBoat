//
//  SegmentPagingEx.swift
//  HR Finance
//
//  Created by vikas on 18/09/20.
//  Copyright © 2020 Appcare Apple. All rights reserved.
//

import Foundation
import UIKit

//Adding child classes to vc and rendering data based on segment selected.
class ViewEmbedder {
    
    class func embed(parent:UIViewController,container:UIView,child:UIViewController,previous:UIViewController?){
        
        if let previous = previous {
            removeFromParent(vc: previous)
        }
        
        child.willMove(toParent: parent)
        parent.addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: parent)
        let w = container.frame.size.width;
        let h = container.frame.size.height;
        child.view.frame = CGRect(x: 0, y: 0, width: w, height: h)
    }
    
    class func removeFromParent(vc:UIViewController){
        vc.willMove(toParent: nil)
        vc.view.removeFromSuperview()
        vc.removeFromParent()
    }
    
    class func embed(withIdentifier id:String, parent:UIViewController, container:UIView, completion:((UIViewController)->Void)? = nil){
        let vc = parent.storyboard!.instantiateViewController(withIdentifier: id)
        embed(
            parent: parent,
            container: container,
            child: vc,
            previous: parent.children.first
        )
        completion?(vc)
    }
}

//MARK:- change font and text size of segment controller

extension UISegmentedControl {
    func font(name:String?, size:CGFloat?, selectedState: UISegmentedControl.State) {
        let attributedSegmentFont = NSDictionary(object: UIFont(name: name!, size: size!)!, forKey: NSAttributedString.Key.font as NSCopying)
        setTitleTextAttributes(attributedSegmentFont as [NSObject : AnyObject] as [NSObject : AnyObject] as? [NSAttributedString.Key : Any], for: selectedState)
        //setTitleTextAttributes([NSAttributedString.Key.foregroundColor: color], for: selectedState)
    }
}
