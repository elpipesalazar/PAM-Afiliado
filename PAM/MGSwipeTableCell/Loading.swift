//
//  Loading.swift
//  Guia de aves de Argentina y Uruguay
//
//  Created by Francisco Miranda Gutierrez on 29-08-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit
import MBProgressHUD

final class Loading {
    
    // MARK: Muestra la ventana de cargando
    static func showLoading(targetVC: UIView, offset: Float?, title: String) -> Void {
        let loadingNotification = MBProgressHUD.showHUDAddedTo(targetVC, animated: true)
        loadingNotification.mode = MBProgressHUDMode.Indeterminate
        loadingNotification.labelText = title
        
        if(offset != nil){
            loadingNotification.yOffset = offset!
        }
    }
    
    // MARK: Oculta la ventana de cargando
    static func hideLoading(targetVC: UIView) -> Void {
        MBProgressHUD.hideAllHUDsForView(targetVC, animated: true)
    }
    
}
