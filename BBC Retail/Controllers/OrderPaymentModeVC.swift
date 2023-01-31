//
//  OrderPaymentModeVC.swift
//  BBC Retail
//
//  Created by Pratibha on 07/11/22.
//

import UIKit
import FTIndicator
// MARK: PROTOCOLS
protocol setBack{
    func returnBack(orderId:Int)
}

class OrderPaymentModeVC: UIViewController {
    //MARK: IBOUTLET
    @IBOutlet weak var btnCashSelect: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    //MARK: VARIABLES
    var delegate : setBack?
    var orderId = 0
    var userid = ""
    var storeName = ""
    var cartMainid = ""
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonCashSelect(_ sender: UIButton) {
        self.generateOrderByRetailer(user_id: self.userid, store_name: Singleton.sharedInstance.retailerData.StoreName ?? "", cart_main_id: self.cartMainid, store_type: Singleton.sharedInstance.retailerData.storeType ?? "")
    }
    //MARK: API FUNCTION
    func generateOrderByRetailer(user_id: String, store_name: String, cart_main_id: String, store_type: String){
        WebServiceManager.sharedInstance.generateOrderByRetailer(user_id: user_id, store_name: store_name, cart_main_id: cart_main_id, store_type: store_type) { order_Id, msg, status in
            if status == "1"{
                self.orderId = order_Id ?? 0
                self.OrderSuccessByRetailer(user_id: self.userid, method_type: "Cash", cart_main_id: self.cartMainid, store_type: Singleton.sharedInstance.retailerData.storeType ?? "", order_id: "\(order_Id ?? 0)", response_type: "Completed")
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    func OrderSuccessByRetailer(user_id: String, method_type: String, cart_main_id: String, store_type: String, order_id: String, response_type: String){
        WebServiceManager.sharedInstance.OrderSuccessByRetailer(user_id: user_id, method_type: method_type, cart_main_id: cart_main_id, store_type: store_type, order_id: order_id, response_type: response_type) { msg, status in
            if status == "1" {
                if let del = self.delegate{
                    self.dismiss(animated: true)
                    del.returnBack(orderId: self.orderId)
                }
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
}
