//
//  ClientList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Modelo ClientList
 
 Es donde se almacena y procesa la informacion de los planes
 */
class ClientList: NSObject {
    
    /// Array con todos los clientes
    var items: [ClientItem] = []
    
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
        self.items.removeAll()
        
        for client in items as! NSArray {
            let clientItem = ClientItem()
            clientItem.code = client["codigo"] as! String
            clientItem.name = client["nombre"] as! String
            clientItem.identification = client["tipodoc"] as? String
            
            self.items.append(clientItem)
        }
        
    }
    
    /**
     Metodo que obtiene la informacion de un elemento en particular
     */
    func getItem(index: Int) -> ClientItem {
        return items[index]
    }
    
}
