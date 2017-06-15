//
//  AdviceViewController+Datasource.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class AdvicesDataSource {
    
    var apiManager: FuckinGreatAdviceApiProtocol = FuckinGreatAdviceApi()
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    var delegate: AdvicesDataSourceDelegate?
    
    public func getRandomAdvice() {
        self.apiManager.getRandomAdvice { [unowned self] (model, error) in
            DispatchQueue.main.async {
                if let model = model {
                    if let storeModel = self.search(model: model) {
                        model.favorite = storeModel.favorite
                    }
                    self.delegate?.advice(model, inDatasource: self)
                }
                else if let error = error {
                    self.delegate?.error(error, inDatasource: self)
                }
            }
        }
    }
    
    public func saveAdvice(_ advice: ApiAdviceModel) {
        guard let container = self.container else { return }
        _ = StoreAdviceModel.adviceModelWith(apiModel: advice, inContext: container.viewContext)
        try? container.viewContext.save()
    }
    
    public func deleteAdvice(_ advice: ApiAdviceModel) {
        guard let container = self.container else { return }
        if let storeModel = self.search(model: advice) {
            container.viewContext.delete(storeModel)
            try? container.viewContext.save()
        }
    }
    
    private func search(model: ApiAdviceModel) -> StoreAdviceModel? {
        guard let id = model.id else { return nil }
        let request: NSFetchRequest<StoreAdviceModel> = StoreAdviceModel.fetchRequest()
        request.predicate = NSPredicate(format: "id = \(id)")
        let results = try? self.container?.viewContext.fetch(request)
        if let storeModel = results??.first {
            return storeModel
        }
        return nil
    }
}

protocol AdvicesDataSourceDelegate {
    func advice(_ advice: ApiAdviceModel, inDatasource: AdvicesDataSource)
    func error(_ error: Error, inDatasource: AdvicesDataSource)
}
