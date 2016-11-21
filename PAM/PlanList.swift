//
//  PlanList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Modelo PlanList
 
 Es donde se almacena y procesa la informacion de los planes
 */
class PlanList: NSObject {
    
    /// Array con todos los planes
    var items: [PlanItem] = []
    
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
        
        for plan in items as! NSArray {
            let planItem = PlanItem()
            planItem.id = plan["idprograma"] as! String
            planItem.name = plan["programa"] as! String
            planItem.isVip = false
            //planItem.isVip = plan["isVip"] as! Bool
            
            self.items.append(planItem)
        }
    }
    
    /**
     Metodo que obtiene la informacion de un elemento en particular
     */
    func getItem(index: Int) -> PlanItem {
        return items[index]
    }
    
}

extension PlanList: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:PlanViewCell = tableView.dequeueReusableCellWithIdentifier("PlanCell") as! PlanViewCell
        let item = self.items[indexPath.row]
        
        cell.name.text = "\(item.name)"
        
        if (item.isVip == false){
            cell.vip.alpha = 0
        } else {
            cell.vip.alpha = 1
        }
        
        return cell
    }
}