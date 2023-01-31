//
//  allSlotBottomCell.swift
//  BBC Retail
//
//  Created by Shubham on 12/10/22.
//

import UIKit

class allSlotBottomCell: UITableViewCell {
    
 
    @IBOutlet weak var desView: UIView!
    @IBOutlet weak var lblDescr: UILabel!
    
    @IBOutlet weak var lblTime: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var btnOrderDetailHandler:(()->())?
    @IBAction func btnOrderDetail(_ sender: UIButton) {
        btnOrderDetailHandler?()
    }
    
}
