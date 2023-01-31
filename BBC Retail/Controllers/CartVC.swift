//
//  CartVC.swift
//  BBC Retail
//
//  Created by Pratibha on 07/11/22.
//

import UIKit
import FTIndicator
import Kingfisher

class CartVC: UIViewController , setBackFromPayment, setBack , goToDetail{
    //MARK: PROTOCOL
    func pushToDetail(orderId:Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as! OrderDetailController
        vc.orderIdAppointmemnt = "\(orderId)"
        vc.isComingFromAppointment = "Self Booking"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func returnBack(orderId: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentSuccessfulVC") as! PaymentSuccessfulVC
        vc.amountPaid = self.arrCartinfo?.totalAmount ?? ""
        vc.delegateForPush = self
        vc.delegateCall = self
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        vc.orderId = orderId
        self.present(vc, animated: true, completion: nil)
    }
    func backReturnFromPayment() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardController") as! DashboardController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: IBOUTLET
    @IBOutlet weak var viewProceedButton: UIView!
    @IBOutlet weak var buttonProceed: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var cartTableView: UITableView!
    //MARK: VARIABLES
    var arrCartinfo : CartInfo?
    var arrProductList : [Productlist]?
    var userId = ""
    var quantityChange = ""
    var quantity = 1
    var indexSelec = 0
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.showIndicator()
        self.getCartDetailsByRetailer(user_id: self.userId)
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonCheckout(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderPaymentModeVC") as! OrderPaymentModeVC
        vc.delegate = self
        vc.userid = self.userId
        vc.cartMainid = self.arrCartinfo?.cartMainid ?? ""
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - BUTTON TAG ACTION
    @objc func removeItem(sender:UIButton){
        self.deleteCartitem(cart_id: self.arrProductList?[sender.tag].cartId ?? "", user_id: self.userId, cart_main_id: self.arrProductList?[sender.tag].cartMainid ?? "")
        self.showIndicator()
    }
    @objc func increaseQuantity(sender:UIButton){
        self.quantityChange = "1"
        self.indexSelec = sender.tag
        let value = Int(arrCartinfo?.totalQty ?? "") ?? 0
        let value1 = value + 1
        print("Adding VAlue ====",value1)
        self.showIndicator()

        self.updateCartQty(cart_id: self.arrProductList?[sender.tag].cartId ?? "", productQuantity: self.arrProductList?[sender.tag].productTotalQuantity ?? "", user_id: self.userId, qty: "\(value1)", cart_main_id: self.arrProductList?[sender.tag].cartMainid ?? "")
    }
    @objc func decreaseQuantity(sender:UIButton){
        self.quantityChange = "2"
        self.indexSelec = sender.tag
        let value = Int(arrCartinfo?.totalQty ?? "") ?? 0
        let value1 = value - 1
        print("Adding VAlue ====",value1)
        if value1 == 0{
            FTIndicator.showToastMessage("Minimum quantity is not less then 1")
        }else{
            self.showIndicator()
            self.updateCartQty(cart_id: self.arrProductList?[sender.tag].cartId ?? "", productQuantity: self.arrProductList?[sender.tag].productTotalQuantity ?? "", user_id: self.userId, qty: "\(value1)", cart_main_id: self.arrProductList?[sender.tag].cartMainid ?? "")
        }
    }
    //MARK: API FUNCTION
    func getCartDetailsByRetailer(user_id:String){
        WebServiceManager.sharedInstance.getCartDetailsByRetailer(user_id: user_id) { cartinfo ,productlist , msg, status in
            self.hideIndicator()
            if status == "1"{
                self.arrCartinfo = cartinfo
                self.arrProductList = productlist
                self.lblTotal.text = "Total: \(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(self.arrProductList?[0].totalPrice ?? "")"
                
                if self.arrProductList?.count ?? 0 == 0{
                    self.buttonProceed.alpha = 0
                    self.buttonProceed.isHidden = true
                    self.lblTotal.isHidden = true
                    self.lblTotal.alpha = 0
                    self.cartTableView.setEmptyMessage1("No item found")
                    self.viewProceedButton.alpha = 0
                    self.viewProceedButton.isHidden = true
                }else{
                    self.cartTableView.restore()
                    self.buttonProceed.alpha = 1
                    self.lblTotal.alpha = 1
                    self.buttonProceed.isHidden = false
                    self.lblTotal.isHidden = false
                    self.viewProceedButton.alpha = 1
                    self.viewProceedButton.isHidden = false
                }
                self.cartTableView.reloadData()
            }else{
                self.arrCartinfo = nil
                self.arrProductList?.removeAll()
                self.buttonProceed.alpha = 0
                self.buttonProceed.isHidden = true
                self.lblTotal.isHidden = true
                self.lblTotal.alpha = 0
                self.cartTableView.setEmptyMessage1("No item found")
                self.viewProceedButton.alpha = 0
                self.viewProceedButton.isHidden = true
                self.cartTableView.reloadData()
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    func updateCartQty(cart_id: String, productQuantity: String, user_id: String, qty: String, cart_main_id: String){
        WebServiceManager.sharedInstance.updateCartQty(cart_id: cart_id, productQuantity: productQuantity, user_id: user_id, qty: qty, cart_main_id: cart_main_id) { filepath, msg, status in
            if status == "1"{
                if self.quantityChange == "1"{
                    self.getCartDetailsByRetailer(user_id: self.userId)
                }else{
                    self.getCartDetailsByRetailer(user_id: self.userId)
                }
            }else{
                FTIndicator.showToastMessage(msg)
            }
        }
    }
    
    func deleteCartitem(cart_id: String, user_id: String, cart_main_id: String){
        WebServiceManager.sharedInstance.deleteCartitem(cart_id: cart_id, user_id: user_id, cart_main_id: cart_main_id) { filepath, msg, status in
            if status == "1"{
                self.hideIndicator()
                if self.arrProductList?.count ?? 0 == 0{
                    self.cartTableView.setEmptyMessage1("No item found")
                    self.cartTableView.isHidden = true
                    self.buttonProceed.alpha = 0
                    self.buttonProceed.isHidden = true
                    self.lblTotal.isHidden = true
                    self.lblTotal.alpha = 0
                    
                }else{
                    self.cartTableView.restore()
                    self.cartTableView.isHidden = false
                    self.buttonProceed.isHidden = false
                    self.lblTotal.isHidden = false
                    self.buttonProceed.alpha = 1
                    self.lblTotal.alpha = 1
                }
                self.getCartDetailsByRetailer(user_id: self.userId)
            }else{
                self.hideIndicator()
                FTIndicator.showToastMessage(msg)
            }
        }
    }
}
//MARK: UITABLEVIEW CELL
class cartCell: UITableViewCell{
    @IBOutlet weak var imgItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgRemove: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnDecrease: UIButton!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var btnIncrease: UIButton!
}
//MARK: EXTENSION UITABLE VIEW DELEGATE AND DATA SOURCE
extension CartVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrProductList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! cartCell
        cell.lblName.text = self.arrProductList?[indexPath.row].productName ?? ""
        cell.lblPrice.text = "\(Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? "") \(self.arrProductList?[indexPath.row].productOfferPrice ?? "")"
        cell.lblQuantity.text = self.arrProductList?[indexPath.row].productQuantity ?? ""
        
        let url = URL(string: self.arrProductList?[indexPath.row].productImage ?? "")
        cell.imgItem.kf.indicatorType = .activity
        cell.imgItem.kf.setImage(with: url, placeholder: UIImage(named: "image-plus"), options: [.transition(.fade(0.7))], progressBlock: nil)
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(removeItem(sender:)), for: .touchUpInside)
        cell.btnDecrease.tag = indexPath.row
        cell.btnDecrease.addTarget(self, action: #selector(decreaseQuantity(sender:)), for: .touchUpInside)
        cell.btnIncrease.tag = indexPath.row
        cell.btnIncrease.addTarget(self, action: #selector(increaseQuantity(sender:)), for: .touchUpInside)
        return cell
    }
    
    
}

