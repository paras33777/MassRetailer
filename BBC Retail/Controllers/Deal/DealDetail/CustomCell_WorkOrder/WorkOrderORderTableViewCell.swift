//
//  WorkOrderORderTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 08/01/23.
//

import UIKit

class WorkOrderORderTableViewCell: UITableViewCell {
    @IBOutlet weak var orderIdLabelContant: UILabel!
    @IBOutlet weak var orderIdLabel: UILabel!
    
    @IBOutlet weak var dealIdLabelContant: UILabel!
    @IBOutlet weak var dealIdLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var quantityLabelContant: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var statusLabelContant: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var dateLabelContant: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var manfacturingWorkOrderListInfo: ManfacturingWorkOrderListInfo?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(){
    self.orderIdLabelContant.text = DetailDealListConstant_Store.dealOrderID
    self.dealIdLabelContant.text = DetailDealListConstant_Store.dealDealID
    self.quantityLabelContant.text = DetailDealListConstant.Quantity
       
        self.statusLabelContant.text = WorkOrderDetailConstant.dealStatus
       self.dateLabelContant.text = WorkOrderDetailConstant.dealDate
        
        
        
    self.dealIdLabelContant.font = UIFont().MontserratSemiBold(size: 14.0)
    self.dealIdLabel.font = UIFont().MontserratSemiBold(size: 14.0)
  
        self.productNameLabel.font = UIFont().MontserratRegular(size: 13.0)
        self.statusLabelContant.font = UIFont().MontserratRegular(size: 13.0)
        self.statusLabel.font = UIFont().MontserratRegular(size: 13.0)
        
        self.priceLabel.font = UIFont().MontserratRegular(size: 13.0)
        self.quantityLabelContant.font = UIFont().MontserratRegular(size: 13.0)
        self.quantityLabel.font = UIFont().MontserratRegular(size: 13.0)
        
        
        self.dateLabel.font = UIFont().MontserratRegular(size: 13.0)
        self.dateLabelContant.font = UIFont().MontserratRegular(size: 13.0)
        
        
        self.orderIdLabel.text = self.manfacturingWorkOrderListInfo?.orderId ?? ""
        self.dealIdLabel.text = self.manfacturingWorkOrderListInfo?.dealId ?? ""
        self.productNameLabel.text = self.manfacturingWorkOrderListInfo?.productName ?? ""
       
        let currency = self.manfacturingWorkOrderListInfo?.currency ?? ""
        let totalAmount = self.manfacturingWorkOrderListInfo?.totalAmount ?? ""
        
        
        self.productNameLabel.text = currency + totalAmount
  
        self.statusLabel.text = self.manfacturingWorkOrderListInfo?.orderStatus ?? ""
       
        let orderDate = self.manfacturingWorkOrderListInfo?.orderdate ?? ""
        let orderTime = self.manfacturingWorkOrderListInfo?.orderTime ?? ""
        
        let date = orderDate + "||" + orderTime
        self.dateLabel.text = date
        
        
    }

}
