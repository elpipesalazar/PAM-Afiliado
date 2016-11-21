//
//  Alerts.swift
//  Guia de aves de Argentina y Uruguay
//
//  Created by Francisco Miranda Gutierrez on 29-08-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

final class Alerts {
    
    static let prefs:NSUserDefaults = Utilities.prefs
    
    static func showSimpleAlert(targetVC: UIViewController, title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        }))
        
        targetVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showCompleteAlert(targetVC: UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            targetVC.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        targetVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showNavigationAlert(targetVC: UIViewController, title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            targetVC.navigationController?.popViewControllerAnimated(true)
        }))
        
        targetVC.presentViewController(alert, animated: true, completion: nil)
    }
    
    static func showCallAlert(targetVC: UIViewController, title:String, message:String, phone:String, closeView:Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Llamar al call center", style: .Default, handler: { (action) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "tel://+\(phone)")!)
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { (action) -> Void in
            if closeView {
                targetVC.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }))
        
        targetVC.presentViewController(alert, animated: true, completion: nil)
    }
    
}