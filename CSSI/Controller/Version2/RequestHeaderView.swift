
//
//  RequestHeaderView.swift
//  CSSI
//
//  Created by apple on 4/19/19.
//  Copyright © 2019 yujdesigns. All rights reserved.
//

import UIKit


class RequestHeaderView: UITableViewCell {

    @IBOutlet weak var lblCaptainName: UILabel!
    @IBOutlet weak var lblGroupNumber: UILabel!
    @IBOutlet weak var viewGroupNumber: UIView!
    
    @IBOutlet weak var viewOptionHeaders: UIView!
    @IBOutlet weak var lblTrance: UILabel!
    @IBOutlet weak var lblNineHoles: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTrance.font = AppFonts.semibold18
        self.lblTrance.textColor = APPColor.textColor.primary
        self.lblNineHoles.font = AppFonts.semibold18
        self.lblNineHoles.textColor = APPColor.textColor.primary
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
