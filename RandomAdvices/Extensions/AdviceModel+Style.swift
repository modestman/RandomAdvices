//
//  AdviceModel+Style.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 14.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import UIKit

extension ApiAdviceModel {
    
    public func attributedStringWith(fontSize: Int) -> NSAttributedString? {
       
        if let text = self.text {
            let html = "<span style=\"font-size:\(fontSize)px; font-family: -apple-system, Helvetica Neue;\">\(text)</span>"
            guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
            guard let attrStr = try? NSMutableAttributedString(data: data,
                                                               options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                               documentAttributes: nil) else { return nil }
            return attrStr
        }
        return nil        
    }
}
