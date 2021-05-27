//
//  AlertActions.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 17/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

public func showAlertMessage(vc: UIViewController, titleStr:String, messageStr:String) -> Void {
    let alert = UIAlertController(title: titleStr, message: messageStr, preferredStyle: UIAlertController.Style.alert);
    vc.present(alert, animated: true, completion: nil)
    
    DispatchQueue.main.asyncAfter(deadline: .now()+2) {
        alert.dismiss(animated: true, completion: nil)
    }
}

protocol ShowAlert {}



extension ShowAlert where Self: UIViewController {
    func showAlert(title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
