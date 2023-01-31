//
//  WorkOrderBasicTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 08/01/23.
//

import UIKit

class WorkOrderBasicTableViewCell: UITableViewCell {
  
    @IBOutlet weak var orderIdLabelContant: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var dealIdLabelContant: UILabel!
    @IBOutlet weak var dealIdLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var storeLabelContant: UILabel!
    @IBOutlet weak var storeLabel: UILabel!

    @IBOutlet weak var dateLabelContant: UILabel!
   
    var manfacturingWorkOrderListInfo:ManfacturingWorkOrderListInfo?
    
    
    // Sales Ord
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(){
        self.orderIdLabelContant.text = DetailDealListConstant_Store.dealOrderID
        self.dealIdLabelContant.text = DetailDealListConstant_Store.dealDealID
        self.storeLabelContant.text = DetailDealListConstant_Store.dealStoreName
        
        self.dealIdLabelContant.font = UIFont().MontserratSemiBold(size: 14.0)
        self.dealIdLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        
        self.orderIdLabelContant.font = UIFont().MontserratSemiBold(size: 14.0)
        self.orderIdLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        
        self.userNameLabel.font = UIFont().MontserratRegular(size: 13.0)
        
        self.phoneLabel.font = UIFont().MontserratRegular(size: 13.0)
        
        self.emailLabel.font = UIFont().MontserratRegular(size: 13.0)
        
        self.storeLabelContant.font = UIFont().MontserratRegular(size: 13.0)
        self.storeLabel.font = UIFont().MontserratRegular(size: 13.0)
        self.dateLabelContant.font = UIFont().MontserratRegular(size: 13.0)
        
        self.orderIdLabel.text = self.manfacturingWorkOrderListInfo?.orderId ?? ""
        self.dealIdLabel.text = self.manfacturingWorkOrderListInfo?.dealId ?? ""
        self.userNameLabel.text = self.manfacturingWorkOrderListInfo?.userName ?? ""
       
        var number = self.manfacturingWorkOrderListInfo?.userMobile ?? ""
        let userMobileCode = self.manfacturingWorkOrderListInfo?.userMobileCode ?? ""
         number = "+" + userMobileCode + number
        
        self.phoneLabel.text = number
        self.storeLabel.text = self.manfacturingWorkOrderListInfo?.storeName ?? ""
       
        let orderDate = self.manfacturingWorkOrderListInfo?.orderdate ?? ""
        let orderTime = self.manfacturingWorkOrderListInfo?.orderTime ?? ""
        
        let date = orderDate + "||" + orderTime
        self.dateLabelContant.text = date
        
     }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
