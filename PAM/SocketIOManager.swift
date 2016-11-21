//
//  SocketIOManager.swift
//  Big Boss TV
//
//  Created by Francisco Miranda Gutierrez on 09-05-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import SocketIOClientSwift

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()
    
    override init() {
        super.init()
    }
    
    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: "http://201.236.236.58:5000")!)
    
    func establishConnection(){
        socket.connect()
        
        socket.on("connect") {data, ack in
            print("socket connected")
        }
    }
    
    func closeConnection(){
        socket.disconnect()
    }
    
    func getCoordsProv(completionHandler: (info:NSDictionary) -> Void) {
        socket.on("coordsProv") { (data, socketAck) -> Void in
            let infoSocket = data[0] as! NSDictionary
        
            completionHandler(info: infoSocket)
        }
    }

}
