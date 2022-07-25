//
//  CustomNewRegCell.swift
//  CSSI
//
//  Created by apple on 2/27/19.
//  Copyright © 2019 yujdesigns. All rights reserved.
//

import UIKit
protocol RegistrationCell: AnyObject {
    func addNewPopOverClicked(cell: CustomNewRegCell)
    func clearButtonClicked(cell: CustomNewRegCell)
    func threeDotsClickedToMoveGroup(cell: CustomNewRegCell)
    func editClicked(cell: CustomNewRegCell)

}

protocol RegistrationDiningCell: AnyObject {
    func addNewPopOverClickedDining(cell: CustomNewRegCell)
}
class CustomNewRegCell: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var txtSearchField: UITextField!
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var playersTableView: UITableView!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var viewSearchField: UIView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnThreeDots: UIButton!
    //Added by kiran V2.5 -- GATHER0000606 -- included the clear btn and line lbl in a view so that it can be hidden easily.
    //GATHER0000606 -- Start
    @IBOutlet weak var viewClearBtn: UIView!
    //GATHER0000606 -- End
    weak var delegate: RegistrationCell?
    weak var delegateDining: RegistrationDiningCell?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func editClicked(_ sender: Any) {
        delegate?.editClicked(cell: self)
    }
    @IBAction func clearClicked(_ sender: Any) {
        delegate?.clearButtonClicked(cell: self)

    }
    
    @IBAction func threeDotsClicked(_ sender: Any) {
        delegate?.threeDotsClickedToMoveGroup(cell: self)
    }
    @IBAction func addPopOverClicked(_ sender: Any) {
        delegate?.addNewPopOverClicked(cell: self)

    }
    
    @IBAction func addPopOverDiningClicked(_ sender: Any) {
        delegateDining?.addNewPopOverClickedDining(cell: self)

    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegCell", for: indexPath) as! CustomNewRegCell
            
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
