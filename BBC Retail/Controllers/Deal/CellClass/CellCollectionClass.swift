//
//  CellCollectionClass.swift
//  BBC Retail
//
//  Created by Sanjeet on 26/12/22.
//

import UIKit

class CellCollectionClass: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}


//MARK :- ****** COLLECTION VIEW CELL ******
class meterialsListCell : UICollectionViewCell{
    @IBOutlet weak var lbl_Name : UILabel!
    
}

/*class dealListCell : UITableViewCell {
    
    @IBOutlet weak var view_response : UIView!
    @IBOutlet weak var lbl_response : UILabel!
    
    @IBOutlet weak var lbl_dealId: UILabel!
    @IBOutlet weak var lbl_UserName: UILabel!
    @IBOutlet weak var lbl_quantity: UILabel!
    @IBOutlet weak var lbl_productCount: UILabel!
    @IBOutlet weak var lbl_amount: UILabel!
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var lbl_productName: UILabel!
}
*/

//MARK:- TABLE VIEW CELL CLASS ====
class filterByListCell : UITableViewCell{
    @IBOutlet weak var lbl_FilterName : UILabel!
    @IBOutlet weak var btn_SelectedProduct : UIButton!
}

//MARK :- ****** COLLECTION VIEW CELL ******
class filterByCell : UICollectionViewCell{
    @IBOutlet weak var lbl_FilterName : UILabel!
    
}


class workFlowListCell : UITableViewCell{
    @IBOutlet weak var lbl_OrderResponse : UILabel!
    @IBOutlet weak var lbl_OrderStatus : UILabel!
    @IBOutlet weak var lbl_name : UILabel!
    @IBOutlet weak var img_status : UIImageView!
    @IBOutlet weak var lbl_date : UILabel!
    @IBOutlet weak var view_topLine : UIView!
    @IBOutlet weak var view_bottomLine : UIView!
    @IBOutlet weak var view_BGStatus : UIView!
    @IBOutlet weak var  top_orderRespnse: NSLayoutConstraint!
    @IBOutlet weak var  top_Respnse: NSLayoutConstraint!
    
}
