//
//  SelectionTableViewCell.swift
//  CurrencyConverter
//
//  Created by Xiaoxiao on 3/15/16.
//  Copyright © 2016 WangXiaoxiao. All rights reserved.
//

import UIKit

class SelectionTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
