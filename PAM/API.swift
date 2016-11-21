//
//  API.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 27-09-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

/**
 Clase que hace la conexion con el servidor
 */
class API {
    
    /// Variable estatica que tiene la ruta PATH para los servicios
    static let pathURL = "http://201.236.236.58:5806/ws_vs2"
    
    /// Obtiene los clientes segun pais
    class func getClientsByCountry(clientList: ClientList, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/cuenta", parameters: ["country": country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res 
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                                let listClients: AnyObject! = result["cliente"]
                                clientList.loadItems(listClients)
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Login
    class func login(username: String, password: String, deviceToken: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/login_mejorado", parameters: ["usuario":username, "clave":password, "DeviceToken":deviceToken, "DialToken":"ios"])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            //print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                                let cveAfiliado:String = result["cveafiliado"] as! String
                                let accountId:String = result["idcuenta"] as! String
                                let country:String = result["idpais"] as! String
                                let phone:String = result["numero_cuenta"] as! String
                                
                                let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                                prefs.setValue(cveAfiliado, forKey: "cveafiliado")
                                prefs.setValue(accountId, forKey: "idcuenta")
                                prefs.setValue(country, forKey: "country")
                                prefs.setValue(phone, forKey: "phone")
                                prefs.setInteger(1, forKey: "isloggedin")
                                prefs.synchronize()
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
     
    /// Registro
    class func register(client: String, cveUser: String, phone: String, email: String, password: String, username: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/registro_mejorado", parameters: ["cliente":client, "cveafiliado":cveUser, "telefono":phone, "correo":email, "clave":password, "usuario":username])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
    }
    
    
    /// Obtiene los planes por cliente
    class func getPlansByClient(planList: PlanList, cveUser: String, clientId: String, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/planes", parameters: ["idcuenta":clientId, "cveafiliado":cveUser, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            //print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                                let listPlans: AnyObject! = result["plan"]
                                planList.loadItems(listPlans)
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Obtiene las asistencias de un plan
    class func getAssistsByPlan(assistanceList: AssistanceList, cveUser: String, clientId: String, planId: String, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/servicio", parameters: ["idcuenta":clientId, "cveafiliado":cveUser, "idplan":planId, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            //print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                                let listAssists: AnyObject! = result["servicio"]
                                assistanceList.loadItems(listAssists)
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    
    /// Envia la informacion a SOAANG
    class func sendSOANNG(cveUser: String, clientId: String, planId: String, assistId: String, lat: Double, lng: Double, esemergencia: Bool, date:String, phone:String, address:String, reference:String, description:String, country:String, responseBlock: (AnyObject?) -> Void ) {
        
        print("Se ejecuta API")
        
        Alamofire.request(.POST, "\(pathURL)/validar_familia", parameters: ["idcuenta":clientId, "cveafiliado":cveUser, "idplan":planId, "idservicio":assistId, "esemergencia":esemergencia, "latitud":lat, "longitud":lng, "fechaprogramacion":date, "telefono":phone, "direccion":address, "referencia":reference, "descripcion":description, "country":country])
            .responseJSON { response in
                
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            //print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Envia la informacion a SOAANG
    class func sendResponsesToSOANNG(cveUser: String, clientId: String, planId: String, assistId: String, lat: Double, lng: Double, esemergencia: Bool, date:String, phone:String, address:String, reference:String, description:String, country:String, responses:[[String: String]], responseBlock: (AnyObject?) -> Void ) {
        
        var formatStringResponses:String = ""
        
        for info in responses {
            let infoResponse = "\(info["id"]!)$\(info["respuesta"]!)$\(info["valor"]!)"
            formatStringResponses += "|\(infoResponse)"
        }
        
        let formatResponses = String(formatStringResponses.characters.dropFirst())
        print(formatResponses)
        
        
        Alamofire.request(.POST, "\(pathURL)/guardar_pregunta", parameters: ["idcuenta":clientId, "cveafiliado":cveUser, "idplan":planId, "idservicio":assistId, "esemergencia":esemergencia, "latitud":lat, "longitud":lng, "fechaprogramacion":date, "telefono":phone, "direccion":address, "referencia":reference, "descripcion":description, "country":country, "respuestas":formatResponses])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    /*
    class func sendSOANNG(cveUser: String, clientId: String, planId: String, assistId: String, lat: Double, lng: Double, esemergencia: Bool, date:String, phone:String, address:String, observation:String, description:String, country:String, responseBlock: (AnyObject?) -> Void ) {

        Alamofire.request(.POST, "\(pathURL)/asistencia", parameters: ["idcuenta":clientId, "cveafiliado":cveUser, "idplan":planId, "idservicio":assistId, "esemergencia":esemergencia, "latitud":lat, "longitud":lng, "fechaprogramacion":date, "telefono":phone, "direccion":address, "observacion":observation, "descripcion":description, "country":country])
            .responseJSON { response in
                
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }*/
    
    
    /// getRequestsUser
    class func getRequestsUser(trackingList: TrackingList, cveUser: String, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/lstasistencia", parameters: ["cveafiliado":cveUser, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            //print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                                let listRequests: AnyObject! = result["asistencia"]
                                trackingList.loadItems(listRequests)
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// cancelRequest
    class func cancelRequest(trackingList: TrackingList, assistId: String, reason: String, country:String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/cancelarasistencia", parameters: ["idasistencia":assistId, "country":country, "motivo":reason])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            print(result)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Arribo proveedor
    final class func arrivalProv(assistId: Int, notificationId: Int, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/conf_afiliado", parameters: ["idasistencia":assistId, "idnotificacion":notificationId, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Listar Notificaciones
    final class func getNotifications(notificationList: NotificationList, cveUser: String, limit: Int, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/listar_notificaciones", parameters: ["cveafiliado":cveUser, "limitador":limit, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            //print(result)
                            
                            if(!responseType){
                                isError = false
                                
                                //print(result["notificaciones"])
                                
                                let listNotifications: AnyObject! = result["notificaciones"]
                                notificationList.loadItems(listNotifications)
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Enviar encuesta
    final class func sendPoll(assistId: Int, rp1: String, rp2: String, rp3: String, country: String, responseBlock: (AnyObject?) -> Void ) {
        Alamofire.request(.POST, "\(pathURL)/encuesta", parameters: ["idasistencia":assistId, "rp1":rp1, "rp2":rp2, "rp3":rp3, "country":country])
            .responseJSON { response in
                if let res = response.response {
                    let resp = res
                    let resCode = resp.statusCode
                    
                    var isError = false
                    
                    switch resCode {
                    case 200:
                        if let d = response.result.value {
                            let result = d
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["mensaje"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                    }
                    
                } else {
                    responseBlock(["code": 408, "error": true, "result": ""])
                }
        }
        
    }
    
    
    /// Logout
    class func logout(userId:Int, accessToken: String, responseBlock: (AnyObject?) -> Void ) {
        let session = NSURLSession.sharedSession()
        let url = NSURL(string: "https://myteamapp.herokuapp.com/api/v1.1/private/logout")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Token token=\(accessToken)", forHTTPHeaderField: "Authorization")
        
        let parameters = ["user_id":userId]
        
        let data = try! NSJSONSerialization.dataWithJSONObject(parameters, options: NSJSONWritingOptions.PrettyPrinted)
        request.HTTPBody = data
        
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let res = response {
                let resp = res as! NSHTTPURLResponse
                let resCode = resp.statusCode
                
                var isError = false
                
                switch resCode {
                    case 200:
                        if let d = data {
                            let result = try! NSJSONSerialization.JSONObjectWithData(d, options: NSJSONReadingOptions.AllowFragments)
                            
                            let responseType: Bool! = result["error"] as! Bool
                            let responseMessage: String! = result["message"] as! String
                            
                            if(!responseType){
                                isError = false
                                
                            } else {
                                isError = true
                                print("hay un error")
                            }
                            
                            responseBlock(["code": resCode, "error": isError, "result": result, "message": responseMessage])
                        }
                        
                    case 401:
                        print("Error de permisos")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 404:
                        print("No encuentra algun dato en el sistema o no existe la URL")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    case 500:
                        print("Error de sistema")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                        
                    default:
                        print("Existe un error desconocido")
                        isError = true
                        responseBlock(["code": resCode, "error": isError, "result": ""])
                }
                
            } else {
                responseBlock(["code": 408, "error": true, "result": ""])
            }
        }
        
        task.resume()
    }
    
}