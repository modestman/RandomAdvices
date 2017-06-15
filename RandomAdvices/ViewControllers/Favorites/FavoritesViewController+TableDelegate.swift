//
//  FavoritesViewController+TableDelegate.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import Foundation
import UIKit

extension FavoritesViewController {
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
}
