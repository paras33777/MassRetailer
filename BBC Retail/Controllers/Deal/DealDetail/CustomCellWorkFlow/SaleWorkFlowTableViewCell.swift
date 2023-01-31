//
//  SaleWorkFlowTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 08/01/23.
//

import UIKit

class SaleWorkFlowSectionTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bottom_Line: UIView!
    @IBOutlet weak var top_Line: UIView!
    @IBOutlet weak var workFlowImageView: UIImageView!
    @IBOutlet weak var workFlowView: UIView!
    var workFlow : WorkFlow?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateUI(){
       
        self.titleLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.titleLabel.text = ""
        if let status = workFlow?.metaValue
        {
            self.titleLabel.text = status
            switch status.lowercased() {
            case "approved":
                workFlowImageView.image = UIImage.init(named: "orderCreated")
                workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F09536")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
            case "order created":
                workFlowImageView.image = UIImage.init(named: "orderCreated")
                workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F09536")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
            case "order placed":
                workFlowImageView.image = UIImage.init(named: "orderCreated")
                workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F09536")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
            case "pending":
                workFlowImageView.image = UIImage.init(named: "orderCreated")
                workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F09536")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
            case "stores":
                workFlowImageView.image = UIImage.init(named: "stores")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "122C6D")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "122C6D")
            case "store":
                workFlowImageView.image = UIImage.init(named: "stores")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "122C6D")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "122C6D")
            case "production":
                workFlowImageView.image = UIImage.init(named: "production")
                workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "388169")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "388169")
            case "qa":
                workFlowImageView.image = UIImage.init(named: "qa")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "C77B2B")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "C77B2B")
            case "accounting":
                workFlowImageView.image = UIImage.init(named: "accounting")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "782267")
                self.titleLabel.textColor =  UIColor().hexStringToUIColor(hex: "782267")
            case "packaging":
                workFlowImageView.image = UIImage.init(named: "packaging")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "4D76D0")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "4D76D0")
            case "dispatch":
                workFlowImageView.image = UIImage.init(named: "dispatch")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "3C8549")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "3C8549")
            case "complete":
                workFlowImageView.image = UIImage.init(named: "complete")
                workFlowView.backgroundColor = UIColor().hexStringToUIColor(hex: "49A130")
                self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "49A130")
            default:
                break
            }
        }
        
    }
}
