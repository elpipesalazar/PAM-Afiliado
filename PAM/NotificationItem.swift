//
//  NotificationItem.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 28-09-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

/**
 Objeto que refiere a una Notificacion
 
 - Parameters:
    - id: Int
    - message: String
    - typeNotification: String
    - isRead: AnyObject
    - assistId: String
 */
class NotificationItem: NSObject {
    
    var id: Int!
    var message: String!
    var typeNotification: String!
    var isRead: Int!
    var isVisible: Int!
    var assistId: Int?
    var phone: Int?
}