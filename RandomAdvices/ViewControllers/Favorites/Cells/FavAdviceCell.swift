//
//  FavAdviceCell.swift
//  RandomAdvices
//
//  Created by Anton Glezman on 15.06.17.
//  Copyright © 2017 Globus. All rights reserved.
//

import UIKit

class FavAdviceCell: UITableViewCell {

    @IBOutlet weak var adviceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        self.adviceLabel.text = nil
    }
    
    public var viewModel: ApiAdviceModel? {
        didSet {
            self.adviceLabel.attributedText = viewModel?.attributedStringWith(fontSize: 16)
        }
    }
}
