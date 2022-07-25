
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
