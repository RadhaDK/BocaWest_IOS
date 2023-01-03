//
//  CobaltModifyRequestHeaderView.swift
//  CSSI
//
//  Created by Vishal Pandey on 03/01/23.
//  Copyright © 2023 yujdesigns. All rights reserved.
//

import UIKit
protocol CobaltModifyDelegate: AnyObject {
    func addNewButtonClicked(cell: CobaltModifyRequestHeaderView)
    func deleteButtonClicked(cell: CobaltModifyRequestHeaderView)
    func waitListClicked(cell : CobaltModifyRequestHeaderView)
}

extension CobaltModifyDelegate{
    
    func waitListClicked(cell : CobaltModifyRequestHeaderView)
    {
        
    }
}

class CobaltModifyRequestHeaderView: UITableViewCell {
    @IBOutlet weak var btnAddNew: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var lblCaptainName: UILabel!
    @IBOutlet weak var lblGroupNumber: UILabel!
    @IBOutlet weak var heightBWGroup: NSLayoutConstraint!
    @IBOutlet weak var lblConfirmNumber: UILabel!
    @IBOutlet weak var lblCourseValue: UILabel!
    @IBOutlet weak var txtAddMemberOrGuest: UITextField!
    @IBOutlet weak var lblTimeValue: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusValue: UIButton!
    
    @IBOutlet weak var viewWaitlist: UIView!
    @IBOutlet weak var btnWaitlist: UIButton!
    @IBOutlet weak var lblHolesHeader: UILabel!
    @IBOutlet weak var lblTransHeader: UILabel!
    @IBOutlet weak var lblRoundLength: UILabel!
    
    var delegate: CobaltModifyDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func deleteClicked(_ sender: Any) {
        delegate?.deleteButtonClicked(cell: self)
    }
    @IBAction func addPopOverClicked(_ sender: Any) {
        delegate?.addNewButtonClicked(cell: self)
    }
    
    @IBAction func waitlistClicked(_ sender: UIButton) {
        self.delegate?.waitListClicked(cell: self)
    }
    
}
