//
//  StoreAdviceModel+CoreDataClass.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import CoreData


public class StoreAdviceModel: NSManagedObject {

    class func adviceModelWith(apiModel: ApiAdviceModel, inContext context: NSManagedObjectContext) -> StoreAdviceModel? {
        let request: NSFetchRequest<StoreAdviceModel> = StoreAdviceModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(apiModel.id!)")
        if let storeModel = (try? context.fetch(request))?.first {
            return storeModel
        }else {
            let storeModel = StoreAdviceModel(context: context)
            storeModel.id = Int32(apiModel.id!)
            storeModel.text = apiModel.text
            storeModel.favorite = apiModel.favorite
            return storeModel
        }
    }
}
