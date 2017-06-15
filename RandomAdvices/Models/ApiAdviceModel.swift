//
//  AdviceModel.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation

class ApiAdviceModel {
    
    public var id: Int?
    public var text: String?
    public var favorite: Bool = false
    
    init(id: Int, text: String?, favorite: Bool) {
        self.id = id
        self.text = text
        self.favorite = favorite
    }
    
    init(from json: Dictionary<String, Any>) {
        if let id = json["id"] as? String {
            self.id = Int(id)
        }
        self.text = json["text"] as? String
    }
}
