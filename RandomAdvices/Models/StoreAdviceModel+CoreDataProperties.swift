//
//  StoreAdviceModel+CoreDataProperties.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import CoreData


extension StoreAdviceModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreAdviceModel> {
        return NSFetchRequest<StoreAdviceModel>(entityName: "StoreAdviceModel")
    }

    @NSManaged public var id: Int32
    @NSManaged public var text: String?
    @NSManaged public var favorite: Bool

}
