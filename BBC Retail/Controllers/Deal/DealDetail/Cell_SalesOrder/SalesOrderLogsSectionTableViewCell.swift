//
//  SalesOrderLogsSectionTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 07/01/23.
//

import UIKit

class SalesOrderLogsSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabelConstant: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var addLogButton: UIButton!
    
    @IBOutlet weak var addLogButtonHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
