//
//  Utilities.swift
//  Guia de aves de Argentina y Uruguay
//
//  Created by Francisco Miranda Gutierrez on 15-06-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

final class Utilities {
    
    static var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    // MARK: Comprueba si esta logueado o no
    static func checkUser() -> Bool {
        let isUser = self.prefs.boolForKey("isUser")
        
        if isUser {
            return true
        } else {
            return false
        }
    }
    
    // MARK: Comprobacion si el usuario esta conectado a internet
    static func checkIsOnline() -> Bool {
        if Reachability.isConnectedToNetwork() != true {
            return false
        } else {
            return true
        }
    }
    
    // MARK: Conversor de fechas a formato legible
    static func convertDateFormater(date: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
    }
    
}
