//
//  TrackingItem.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 17-12-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Objeto que refiere al Tracking
 
 - Parameters:
    - id: String
    - service: String
    - dateRequest: String
    - lat: Double
    - lng: Double
    - status: Bool
 */
class TrackingItem: NSObject {
    
    var id: String!
    var service: String!
    var dateRequest: String!
    var lat: Double?
    var lng: Double?
    var status: Bool!
    
}
