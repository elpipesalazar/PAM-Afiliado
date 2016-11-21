//
//  OptionQuestionItem.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 11-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

/**
 Objeto que refiere las opciones de una pregunta (Select List)
 
 - Parameters:
    - option: String
    - valueOption: String
    - isNewQuestion: Bool
    - child: Int
    - exit: Bool
 
*/
class OptionQuestionItem: NSObject {
    
    var option: String!
    var valueOption: String!
    var isNewQuestion: String!
    var childQuestion: Int?
    var exitQuestion: String!
    
}
