//
//  Generals.swift
//  PDFKit Dynamic Table
//
//  Created by devmac02 on 7/28/20.
//  Copyright © 2020 prabha. All rights reserved.
//

import UIKit

class Generals {
    
    static func showAlert(title : String!, message : String!)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        Generals.getAppWindow().rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    static func getAppWindow() -> UIWindow
    {
        if #available(iOS 13.0, *) {
            let sceneDelegate = UIApplication.shared.connectedScenes
                .first!.delegate as! SceneDelegate
            return sceneDelegate.window!

        // iOS12 or earlier
        } else {
            // UIApplication.shared.keyWindow?.rootViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.window!
        }
    }
}
