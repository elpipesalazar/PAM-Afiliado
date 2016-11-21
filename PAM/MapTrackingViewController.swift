//
//  MapTrackingViewController.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 16-02-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import GoogleMaps
import MBProgressHUD

class MapTrackingViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var arrivalTime: UILabel!
    
    var trackingItem: TrackingItem!
    
    var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(self.trackingItem.lat!, longitude: self.trackingItem.lng!, zoom: 14.0)
        mapView.camera = camera
        
        let originCoordinate = CLLocationCoordinate2DMake(self.trackingItem.lat!, self.trackingItem.lng!)
        
        let originMarker = GMSMarker(position: originCoordinate)
        originMarker.map = self.mapView
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        SocketIOManager.sharedInstance.getCoordsProv { (info) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                print("muestra socket en la vista: \(info)")
                
                let assistId = info.objectForKey("assistId") as! Int
                
                if(Int(self.trackingItem.id) == assistId){
                    //let distance = info.objectForKey("distance") as! String
                    let time = info.objectForKey("time") as! String
                    let lat = info.objectForKey("lat") as! Double
                    let lng = info.objectForKey("lng") as! Double
                    
                    let originCoordinate = CLLocationCoordinate2DMake(lat, lng)
                    
                    let originMarker = GMSMarker(position: originCoordinate)
                    originMarker.map = nil
                    originMarker.map = self.mapView
                    originMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
                    
                    self.mapView.camera = GMSCameraPosition(target: originCoordinate, zoom: 15, bearing: 0, viewingAngle: 0)
                    
                    self.arrivalTime.text = time
                }
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backView(sender: UIBarButtonItem) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // Arribar proveedores
    func arrivalProv(){
        self.showLoading()
        
        let country:String = self.prefs.objectForKey("country") as! String
        let assistId:String = "\(self.trackingItem.id!)"
        
        API.arrivalProv(assistId, country:country, responseBlock: {
            (response) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.hideLoading()
                
                if let res = response {
                    let error = res.valueForKey("error") as! Bool
                    let code = res.valueForKey("code") as! Int
                    
                    if(error && code == 200){
                        let messageError = res.valueForKey("message") as! String
                        self.showAlert("Lo sentimos!", message: messageError)
                        
                    } else if(error && code != 200 && code != 408) {
                        self.showAlert("Lo sentimos!", message: "Tenemos un problema con nuestro servidor, por favor intenta realizar ésta acción mas tarde.")
                    } else if(error && code == 408) {
                        self.showAlert("Problemas de Conexión!", message: "Revisa que estés conectado a internet por favor.")
                    } else {
                        
                    }
                }
            })
            
        })
    }*/
    
    
    func showLoading() {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = "Cargando"
        loadingNotification.yOffset = -30.0
    }
    
    func hideLoading() {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func showAlertCancel(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            self.navigationController?.popViewControllerAnimated(true)
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showArrival(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .Default, handler: { action in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Si", style: .Default, handler: { action in
            //self.arrivalProv()
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

}
