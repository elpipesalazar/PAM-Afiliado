//
//  NotificationList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 28-09-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

/**
 Modelo NotificationList
 
 Es donde se almacena y procesa la informacion de las notificaciones
 */
class NotificationList: NSObject {
    
    /// Array con todos los planes
    var items: [NotificationItem] = []
    
    /**
     Inicializador de la clase
     */
    override init() {
        super.init()
    }
    
    /**
     Metodo que carga los elementos en el array items
     */
    func loadItems(items: AnyObject) {
        //self.items.removeAll()
        
        for notification in items as! NSArray {
            let isVisible = notification["visible"] as! Int
            
            if isVisible == 1 {
                let notificationItem = NotificationItem()
                
                notificationItem.id = notification["id_notificacion"] as! Int
                notificationItem.message = notification["mensaje"] as! String
                notificationItem.typeNotification = notification["tipo_msj"] as! String
                notificationItem.isRead = notification["leido"] as! Int
                notificationItem.isVisible = notification["visible"] as! Int
                notificationItem.assistId = notification["idasistencia"] as? Int
                notificationItem.phone = notification["numero"] as? Int
                
                self.items.append(notificationItem)
            }
            
        }
    }
    
    /**
     Metodo que obtiene la informacion de un elemento en particular
     */
    func getItem(index: Int) -> NotificationItem {
        return items[index]
    }
    
}
