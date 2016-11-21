//
//  QuestionList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 11-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

/**
 Modelo QuestionList
 
 Es donde se almacena y procesa la informacion de las preguntas
 */
class QuestionList: NSObject {
    
    /// Array con todos las preguntas
    var items: [QuestionItem] = []
    
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
        
        for question in items as! NSArray {
            
            /*
            let clientItem = ClientItem()
            clientItem.code = client["codigo"] as! String
            clientItem.name = client["nombre"] as! String
            clientItem.identification = client["tipodoc"] as? String
            
            self.items.append(clientItem)*/
        }
        
    }
    
    /**
     Metodo que obtiene la informacion de un elemento en particular
     */
    func getItem(index: Int) -> QuestionItem {
        return items[index]
    }
    
}
