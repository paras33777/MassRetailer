//
//  SalesOrderLogsTableViewCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 07/01/23.
//

import UIKit

class SalesOrderLogsTableViewCell: UITableViewCell {
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var logsList:  LogsList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateFont(){
        self.titleLabel.font =  UIFont().MontserratMedium(size: 12.0)
        self.desLabel.font =  UIFont().MontserratMedium(size: 12.0)
        self.userNameLabel.font =  UIFont().MontserratMedium(size: 12.0)
        self.dateLabel.font =  UIFont().MontserratRegular(size: 10.0)
        if let sTATUSCOMMENT = self.logsList?.sTATUSCOMMENT{
             
            
            var sTATUSCOMMENT =  sTATUSCOMMENT.replacingOccurrences(of: "_", with: ",")
            
             sTATUSCOMMENT =  sTATUSCOMMENT.replacingOccurrences(of: " ", with: ",")
            
            
               let  sTATUSCOMMENT_underScore = sTATUSCOMMENT.components(separatedBy: ",")
                
            
            
        
              var part1:String = ""
              var part2:String = ""
            
              if sTATUSCOMMENT_underScore.count > 1{
                   part1 = sTATUSCOMMENT_underScore[0]
                   part2 = sTATUSCOMMENT_underScore[1]
              }
                
                if let status  = logsList?.sTATUS{
                    self.titleLabel.text = status + " For " + part1
                }
                self.desLabel.text =  part2
                self.userNameLabel.text = logsList?.retailerName
                self.dateLabel.text =  Date().convertDateFormat(inputDate: logsList?.dateCreated ?? "")
                
                switch part1.lowercased() {
                case "approved":
                    statusImageView.image = UIImage.init(named: "orderCreated")
                    statusView.backgroundColor =  UIColor().hexStringToUIColor(hex: "F09536")
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
                case "order created":
                    statusImageView.image = UIImage.init(named: "orderCreated")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "F09536")// UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
                case "order placed":
                    statusImageView.image = UIImage.init(named: "orderCreated")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "F09536")// UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
                case "pending":
                    statusImageView.image = UIImage.init(named: "orderCreated")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "F09536")// UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "F09536")
                case "stores":
                    statusImageView.image = UIImage.init(named: "stores")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "122C6D")// UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "122C6D")
                case "store":
                    statusImageView.image = UIImage.init(named: "stores")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "122C6D")// UIColor.init(red: Int(254.0/255.0), green: Int(142.0/255.0), blue: 0)
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "122C6D")
                case "production":
                    statusImageView.image = UIImage.init(named: "production")
                    statusView.backgroundColor =  UIColor().hexStringToUIColor(hex: "388169")
                    self.titleLabel.textColor =   UIColor().hexStringToUIColor(hex: "388169")
                case "qa":
                    statusImageView.image = UIImage.init(named: "qa")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "C77B2B")
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "C77B2B")
                case "accounting":
                    statusImageView.image = UIImage.init(named: "accounting")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "782267")
                    self.titleLabel.textColor =  UIColor().hexStringToUIColor(hex: "782267")
                case "packaging":
                    statusImageView.image = UIImage.init(named: "packaging")
                    statusView.backgroundColor =  UIColor().hexStringToUIColor(hex: "4D76D0")
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "4D76D0")
                case "dispatch":
                    statusImageView.image = UIImage.init(named: "dispatch")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "3C8549")
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "3C8549")
                case "complete":
                    statusImageView.image = UIImage.init(named: "complete")
                    statusView.backgroundColor = UIColor().hexStringToUIColor(hex: "49A130")
                    self.titleLabel.textColor = UIColor().hexStringToUIColor(hex: "49A130")
                default:
                    break
                }
                
                
            
        }
        
        
        
    }
    func updateValues(){
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
