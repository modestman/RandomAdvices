//
//  FavoritesViewController+TableDataSource.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import UIKit

extension FavoritesViewController {
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else {
            fatalError("No sections in fetchedResultsController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavAdviceCell", for: indexPath) as! FavAdviceCell
        let storeModel = self.fetchedResultsController.object(at: indexPath)
        let viewModel = ApiAdviceModel(id: Int(storeModel.id),
                                      text: storeModel.text,
                                      favorite: storeModel.favorite)
        cell.viewModel = viewModel
        return cell
     }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let storedObject = self.fetchedResultsController.object(at: indexPath)
            let id = storedObject.id
            self.container?.viewContext.delete(storedObject)
            try? self.container?.viewContext.save()
            NotificationCenter.default.post(name: .onDeleteFavAdvice, object: id)
        }
    }
}
