//
//  AssistanceList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Modelo AssistanceList
 
 Es donde se almacena y procesa la informacion de los planes
 */
class AssistanceList: NSObject {
    
    /// Array con todas las asistencias
    var items: [AssistanceItem] = []
    
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
        
        for assistance in items as! NSArray {
            let assistanceItem = AssistanceItem()
            assistanceItem.id = assistance["idservicio"] as! String
            assistanceItem.name = assistance["etiqueta"] as? String
            assistanceItem.totalEvents = assistance["eventos"] as! String
            assistanceItem.available = assistance["disponibles"] as? Int
            
            self.items.append(assistanceItem)
        }
        
    }
    
    /**
     Metodo que obtiene la informacion de un elemento en particular
     */
    func getItem(index: Int) -> AssistanceItem {
        return items[index]
    }
}

extension AssistanceList: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:AssistanceViewCell = tableView.dequeueReusableCellWithIdentifier("AssistanceCell") as! AssistanceViewCell
        let item = items[indexPath.row]
        
        if(item.name != nil){
            cell.name.text = "\(item.name!)"
        } else {
            cell.name.text = "Sin nombre"
        }
        
        
        var availables:String = ""
        
        if let countAvailables = item.available {
            availables = "\(countAvailables)"
        } else {
            availables = "Ilimitado"
        }
        
        
        cell.quantity.text = "Disponibles: \(availables)"
        
        return cell
    }
}