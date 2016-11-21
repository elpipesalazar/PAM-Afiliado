//
//  QuestionItem.swift
//  PAM
//
//  Created by Francisco Miranda Gutierrez on 11-10-16.
//  Copyright © 2016 Wingzoft. All rights reserved.
//

import UIKit

/**
 Objeto que refiere a una pregunta
 
 - Parameters:
    - id: String
    - type: String
    - label: String
    - placeholder: String
    - parentQuestion: Bool
    - childrens: NSArray
    - options: [OptionQuestionItem]
*/
class QuestionItem: NSObject {
    
    var id: Int!
    var type: String!
    var label: String!
    var placeholder: String?
    var parentQuestion: String!
    var childrens: AnyObject?
    var options: [OptionQuestionItem]?
    
}
