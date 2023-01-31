//
//  DealListCell.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 02/01/23.
//

import UIKit
class StatusInfo: NSObject {
    var title:String = ""
    var des:String = ""
    var desColor:UIColor = UIColor.black
    var image:UIImage? = UIImage()
    override init() {
        
    }
}
class DealListTableViewCell: UITableViewCell {
    @IBOutlet weak var view_response : UIView!
    @IBOutlet weak var lbl_response : UILabel!
    
    @IBOutlet weak var dealIDLabelCosntant: UILabel!
    @IBOutlet weak var dealIDLabelValue: UILabel!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    
    @IBOutlet weak var retailerLabelProcess: UILabel!
    
    @IBOutlet weak var nameIcon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var quantityIcon: UIImageView!
    @IBOutlet weak var quantityLabelConstant: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var productNameIcon: UIImageView!
    @IBOutlet weak var productNameLabelConstant: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    @IBOutlet weak var amountIcon: UIImageView!
    @IBOutlet weak var amountLabelConstant: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var collectionHeight: NSLayoutConstraint!
    @IBOutlet weak var dateLabel: UILabel!
    var arrStatus:[StatusInfo] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension DealListTableViewCell: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: collectionView.bounds.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrStatus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "DealListCollectionViewCell", for: indexPath) as? DealListCollectionViewCell
        cell?.statusLabel.text = self.arrStatus[indexPath.row].title
        cell?.statusLabel2.text = self.arrStatus[indexPath.row].des
        cell?.statusIcon.image = self.arrStatus[indexPath.row].image
        
        if indexPath.row == 0 {
            cell?.lineRight.isHidden = true
        }else{
            cell?.lineRight.isHidden = false
        }
        
        if indexPath.row == self.arrStatus.count - 1{
            cell?.lineLeft.isHidden = true
        }else{
            cell?.lineLeft.isHidden = false
        }
        cell?.statusLabel2.textColor = self.arrStatus[indexPath.row].desColor
        return cell!
    }
}
