//
//  SettlementPaymentFooterTableViewCell.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 08/12/22.
//

import UIKit

class SettlementPaymentFooterTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var srLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var netAmountLabel: UILabel!
    
    @IBOutlet weak var headerButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
