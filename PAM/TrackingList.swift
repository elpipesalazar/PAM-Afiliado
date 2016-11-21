//
//  TrackingList.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 17-12-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

class TrackingList: NSObject {
    
    var items: [TrackingItem] = []
    
    override init() {
        super.init()
    }
    
    func loadItems(items: AnyObject) {
        self.items.removeAll()
        
        for tracking in items as! NSArray {
            let trackingItem = TrackingItem()
            trackingItem.id = tracking["idasistencia"] as! String
            trackingItem.service = tracking["servicio"] as! String
            trackingItem.dateRequest = tracking["fecharegistro"] as! String
            trackingItem.lat = tracking["latitud"] as? Double
            trackingItem.lng = tracking["longitud"] as? Double
            trackingItem.status = tracking["flag_status"] as! Bool
            
            self.items.append(trackingItem)
        }
    }
    
    func getItem(index: Int) -> TrackingItem {
        return items[index]
    }
    
    func convertDateFormater(date: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "EEEE dd MMMM yyyy"
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
    }
    
    func convertHourFormater(date: String) -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let date = dateFormatter.dateFromString(date)
        
        dateFormatter.dateFormat = "HH:mm"
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
    }
    
}
/*
extension TrackingList: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TrackingViewCell = tableView.dequeueReusableCellWithIdentifier("TrackingCell") as! TrackingViewCell
        let item = self.items[indexPath.row]
        
        cell.service.text = "\(item.service)"

        let arrayDate = item.dateRequest.componentsSeparatedByString(" ")
        let date = arrayDate[0]
        let hour = arrayDate[1]
        
        cell.dateRequest.text = "\(self.convertDateFormater(date).capitalizedString) a las \(self.convertHourFormater(hour))"
        
        return cell
    }
}
*/