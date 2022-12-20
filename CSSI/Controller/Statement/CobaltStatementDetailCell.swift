//
//  CobaltStatementDetailCell.swift
//  CSSI
//
//  Created by Vishal Pandey on 21/12/22.
//  Copyright © 2022 yujdesigns. All rights reserved.
//

import UIKit

class CobaltStatementDetailCell: UITableViewCell {
    @IBOutlet weak var lblNo: UILabel!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblSKUNo: UILabel!
    @IBOutlet weak var lblQty: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblDesignator: UILabel!
    @IBOutlet weak var lblQtyRow: UILabel!
    @IBOutlet weak var lblQtyWidth: NSLayoutConstraint!
    
    @IBOutlet weak var lblQtyRowHeight: NSLayoutConstraint!
    @IBOutlet weak var lblSKUNoHeight: NSLayoutConstraint!
 

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
