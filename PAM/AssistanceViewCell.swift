//
//  AssistanceViewCell.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 18-11-15.
//  Copyright © 2015 Wingzoft. All rights reserved.
//

import UIKit

/**
 Controlador que maneja los metodos de la celda "AssistanceViewCell"
 */
class AssistanceViewCell: UITableViewCell {
    // MARK: IBOutlet
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var quantity: UILabel!
    
    // MARK: Metodos
    /**
     Metodo de inicializacion de la celda.
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /**
     Metodo que configura acciones para la seleccion de la celda.
     */
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
