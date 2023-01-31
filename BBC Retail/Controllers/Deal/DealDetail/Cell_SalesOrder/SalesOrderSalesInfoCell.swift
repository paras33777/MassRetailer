//
//  SalesOrderSalesInfoCell.swift
//  BBC Retail
//
//  Created by rupinder singh on 07/01/23.
//

import UIKit

class SalesOrderSalesInfoCell: UITableViewCell {
    // Sales Order Store
    @IBOutlet weak var store_OrderID_contant: UILabel!
    @IBOutlet weak var store_OrderID_label: UILabel!
    
    @IBOutlet weak var store_dealID_contant: UILabel!
    @IBOutlet weak var store_dealID_label: UILabel!
    
    @IBOutlet weak var store_imageView: UIImageView!
    
    @IBOutlet weak var store_ID_contant: UILabel!
    @IBOutlet weak var store_ID_label: UILabel!
    
    @IBOutlet weak var store_retailerID_contant: UILabel!
    @IBOutlet weak var store_retailer_ID_label: UILabel!
    
    @IBOutlet weak var store_userName_label: UILabel!
    
    @IBOutlet weak var store_contact_label: UILabel!
    
    @IBOutlet weak var store_storeName_contant: UILabel!
    @IBOutlet weak var store_storeName_label: UILabel!
    
    @IBOutlet weak var store_type_contant: UILabel!
    @IBOutlet weak var store_type_label: UILabel!
    
    @IBOutlet weak var store_location_contant: UILabel!
    @IBOutlet weak var store_location_label: UILabel!
    
    @IBOutlet weak var store_category_contant: UILabel!
    @IBOutlet weak var store_category_label: UILabel!
    
    @IBOutlet weak var store_paymentMethod_contant: UILabel!
    @IBOutlet weak var store_paymentMethod_label: UILabel!
    
    @IBOutlet weak var store_qr_contant: UILabel!
    
    @IBOutlet weak var store_qr_imageView: UIImageView!
    
    var storeInfo:StoreInfo?
    
    var dealId : String = ""
    var orderId : String = ""
    
    
    // Sales Order Store
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateSaleOrder_store_UI(){
        self.store_OrderID_contant.text = DetailDealListConstant_Store.dealOrderID
        self.store_dealID_contant.text = DetailDealListConstant_Store.dealDealID
        self.store_ID_contant.text = DetailDealListConstant_Store.dealStoreID
        self.store_retailerID_contant.text = DetailDealListConstant_Store.dealRetailerID
        
        
        if let storeImageSmal = self.storeInfo?.storeImageSmal{
            if let url = URL(string:  storeImageSmal )
            {
                store_imageView.kf.setImage(with: url,placeholder: UIImage.init(named: "dealStoreImage"))
            }
        }else{
            store_imageView.image = UIImage.init(named: "dealStoreImage")
            
        }
        if let storeImageSmal = self.storeInfo?.storeQrCode{
            if let url = URL(string:  storeImageSmal ) {
                store_qr_imageView.kf.setImage(with: url)
            }
        }
        self.store_storeName_contant.text = DetailDealListConstant_Store.dealStoreName
        
        self.store_type_contant.text = DetailDealListConstant_Store.dealType
        
        self.store_location_contant.text = DetailDealListConstant_Store.dealLocation
        self.store_category_contant.text = DetailDealListConstant_Store.dealCategory
        
        
        self.store_paymentMethod_contant.text = DetailDealListConstant_Store.dealPaymentMethod
        
        self.store_OrderID_contant.font = UIFont().MontserratMedium(size: 14.0)
        self.store_OrderID_label.font = UIFont().MontserratMedium(size: 14.0)
        
        self.store_dealID_contant.font = UIFont().MontserratMedium(size: 14.0)
        self.store_dealID_label.font = UIFont().MontserratMedium(size: 14.0)
        
        self.store_ID_contant.font = UIFont().MontserratRegular(size: 14.0)
        self.store_ID_label.font = UIFont().MontserratRegular(size: 14.0)
        
        self.store_retailerID_contant.font = UIFont().MontserratRegular(size: 14.0)
        self.store_retailer_ID_label.font = UIFont().MontserratRegular(size: 14.0)
        
        self.store_userName_label.font = UIFont().MontserratRegular(size: 13.0)
        self.store_contact_label.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_storeName_contant.font = UIFont().MontserratRegular(size: 13.0)
        self.store_storeName_label.font = UIFont().MontserratRegular(size: 13.0)
        
        
        self.store_type_contant.font = UIFont().MontserratRegular(size: 13.0)
        self.store_type_label.font = UIFont().MontserratRegular(size: 13.0)
       
        self.store_location_contant.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_location_label.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_category_contant.font = UIFont().MontserratRegular(size: 13.0)
        self.store_category_label.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_paymentMethod_contant.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_paymentMethod_label.font = UIFont().MontserratRegular(size: 13.0)
        
        self.store_qr_contant.font = UIFont().MontserratRegular(size: 13.0)
        
        guard let url = URL(string: Singleton.sharedInstance.retailerData.RETAILERQRCODE!) else{return}
        store_qr_imageView.kf.setImage(with: url)
        
     }
    func udpateStoreValue_SaleOrder(){
        self.store_dealID_label.isHidden = true
        self.store_dealID_contant.isHidden = true
        self.store_OrderID_label.text = self.dealId
        self.store_OrderID_contant.text = DealListConstant.DealId
        if let storeImageSmal = self.storeInfo?.storeImageSmal{
            if let url = URL(string:  storeImageSmal )
            {
                store_imageView.kf.setImage(with: url,placeholder: UIImage.init(named: "dealStoreImage"))
            }
        }else{
            store_imageView.image = UIImage.init(named: "dealStoreImage")
            
        }
        if let storeImageSmal = self.storeInfo?.storeQrCode{
            if let url = URL(string:  storeImageSmal ) {
                store_qr_imageView.kf.setImage(with: url)
            }
        }
        self.store_ID_label.text = self.storeInfo?.storeId ?? ""
        self.store_retailer_ID_label.text = self.storeInfo?.retailerId ?? ""
        
        self.store_userName_label.text = self.storeInfo?.retailerName ?? ""
        self.store_contact_label.text = self.storeInfo?.contactNumber ?? ""
        
        self.store_storeName_label.text = self.storeInfo?.storeName ?? ""
        
        self.store_type_label.text = self.storeInfo?.storeType ?? ""
        self.store_location_label.text = self.storeInfo?.location ?? ""
       
        self.store_category_label.text = self.storeInfo?.category ?? ""
        
        self.store_paymentMethod_label.text = self.storeInfo?.paymentMethod ?? ""
    }
    func udpateStoreValue_WorkOrder(){
        self.store_OrderID_contant.text = DealListConstant.Orderid
        
        self.store_dealID_label.isHidden = false
        self.store_dealID_contant.isHidden = false
        
        self.store_dealID_label.text = self.dealId
        self.store_OrderID_label.text = self.orderId
     
        if let storeImageSmal = self.storeInfo?.storeImageSmal{
            if let url = URL(string:  storeImageSmal )
            {
                store_imageView.kf.setImage(with: url)
            }
        }
        if let storeImageSmal = self.storeInfo?.storeQrCode{
            if let url = URL(string:  storeImageSmal ) {
                store_qr_imageView.kf.setImage(with: url)
            }
        }
        self.store_ID_label.text = self.storeInfo?.storeId ?? ""
        self.store_retailer_ID_label.text = self.storeInfo?.retailerId ?? ""
        
        self.store_userName_label.text = self.storeInfo?.retailerName ?? ""
        self.store_contact_label.text = self.storeInfo?.contactNumber ?? ""
        
        self.store_storeName_label.text = self.storeInfo?.storeName ?? ""
        
        self.store_type_label.text = self.storeInfo?.storeType ?? ""
        self.store_location_label.text = self.storeInfo?.location ?? ""
       
        self.store_category_label.text = self.storeInfo?.category ?? ""
        
        self.store_paymentMethod_label.text = self.storeInfo?.paymentMethod ?? ""
    }

}
