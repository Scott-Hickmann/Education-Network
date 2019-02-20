//
//  CatalogTableViewCell.swift
//  Education Network
//
//  Created by Scott Hickmann on 12/20/18.
//  Copyright © 2018 Scott Hickmann. All rights reserved.
//

import UIKit

class CatalogTableViewCell: UITableViewCell {

    @IBOutlet weak var catalogItemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
