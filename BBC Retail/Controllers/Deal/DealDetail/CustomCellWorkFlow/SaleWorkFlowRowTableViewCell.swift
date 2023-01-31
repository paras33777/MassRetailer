//
//  SaleWorkFlowRowTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 08/01/23.
//

import UIKit

class SaleWorkFlowRowTableViewCell: UITableViewCell {

    @IBOutlet weak var statusChangeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var bottom_Line: UIView!
    @IBOutlet weak var top_Line: UIView!
    @IBOutlet weak var workFlowImageView: UIImageView!
    
    @IBOutlet weak var workFlowView: UIView!
    @IBOutlet weak var section_Line: UIView!
    
    
    var workflow:WorkFlow?
    var row:Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateUI(){
       
        self.statusChangeLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.statusLabel.font = UIFont().MontserratMedium(size: 11.0)
        self.nameLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.dateLabel.font = UIFont().MontserratMedium(size: 12.0)
        self.statusChangeLabel.text = SaleOrderWorkFlowConstant.StatusChangesto
      
        switch row {
        case 0:
            top_Line.isHidden = true
            bottom_Line.isHidden = false
            if let commentone = self.workflow?.commentone{
                self.statusChangeLabel.text = commentone
            }
            if let assignFrst = self.workflow?.assignFrst{
                self.nameLabel.text = assignFrst
            }
            if let dateone = self.workflow?.dateone{
                self.dateLabel.text = dateone//Date().convertDateFormat(inputDate: dateone)
            }
            workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F19436")
          
            self.statusLabel.textColor = UIColor().hexStringToUIColor(hex: "F19436")
        case 1:
            top_Line.isHidden = false
            bottom_Line.isHidden = true
            if let commentsecond = self.workflow?.commentsecond{
                self.statusChangeLabel.text = commentsecond
                
            }
            if let assignSecond = self.workflow?.assignSecond{
                self.nameLabel.text = assignSecond
            }
            
            if let datesecond = self.workflow?.datesecond{
                self.dateLabel.text = datesecond //Date().convertDateFormat(inputDate: datesecond)
            }
           
            workFlowView.backgroundColor =  UIColor().hexStringToUIColor(hex: "49A130")
            self.statusLabel.textColor = UIColor().hexStringToUIColor(hex: "49A130")
            
        default:
            break
        }
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
