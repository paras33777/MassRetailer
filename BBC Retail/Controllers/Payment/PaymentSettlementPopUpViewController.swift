//
//  PaymentSettlementPopUpViewController.swift
//  BBC Retail
//
//  Created by Newforce MAC on 07/12/22.
//

import UIKit
import FTIndicator
import SwiftPopup
class PaymentSettlementPopUpViewController: SwiftPopup {

    @IBOutlet weak var erroMessageLabel: UILabel!
   
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var staticTotalAmount: UILabel!
    @IBOutlet weak var totalAmount: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var settlebutton: UIButton!
    var settlementData : SettlementData?
    @IBOutlet weak var dataTableview: UITableView!
    
    @IBOutlet weak var buttonInfo: UIButton!
    var stringOrderID:String = ""
    
    @IBOutlet weak var erroMessageList: UILabel!
    
    
    @IBOutlet weak var totalAmountConstant: UILabel!
    @IBOutlet weak var totalAmountValue: UILabel!
    @IBOutlet weak var settlmentButton: UIButton!
    @IBOutlet weak var settlmentBottomView: UIView!
    
    
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var titleLabelList: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        self.headerButton.addTarget(self, action: #selector(crossButtonPressed(sender: )), for: .touchUpInside)
        self.titleLabelList.text = SettleMentControllerConstant.SettlementReport
        
        
        erroMessageLabel.text = ""
        if #available(iOS 13.0, *) {
            let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 17, weight: .medium, scale: .large)
            let image = UIImage(systemName: "info.circle", withConfiguration: imageConfiguration)
            buttonInfo.setImage(image, for: .normal)
        } else {
            // Fallback on earlier versions
        }
        Utility().roundCorner(view: noButton, borderWith: 0.5, borderColor: UIColor.clear,cornerRadius: 5.0)
        Utility().roundCorner(view: settlebutton, borderWith: 0.5, borderColor: UIColor.clear,cornerRadius: 5.0)
        
        
      //  Utility().roundCorner(view: backView, borderWith: 1.0, borderColor: UIColor.lightGray, cornerRadius: 5.0)
        
        self.dataTableview.dataSource = self
        self.dataTableview.delegate = self
        self.getStripeSettlement()
        
        self.totalAmount.font =  UIFont().MontserratBold(size: 17.0)
        self.totalAmountConstant.font =  UIFont().MontserratBold(size: 17.0)
        
        self.totalAmountConstant.text = SettleMentControllerConstant.TotalAmount
        self.settlmentButton.setTitle( SettleMentControllerConstant.SettleAmount, for: .normal)
        Utility().roundCorner(view: self.settlmentButton, borderWith: 0.0, borderColor: UIColor.clear, cornerRadius: 5.0)
        
        self.displayTransactionList()
       
        // Do any additional setup after loading the view.
    }
    func displayTransactionList(){
        self.dataTableview.reloadData()
        self.dataTableview.isHidden = false
        self.backView.isHidden = true
      if settlementData?.orderDetail?.count > 0{
          self.erroMessageList.isHidden = true
      }else{
          self.erroMessageList.isHidden = false
      }
    }
    func displayPopUp(){
        self.dataTableview.isHidden = false
        self.backView.isHidden = true
        self.erroMessageList.isHidden = true
    }
    
    @IBAction func noButtonPressed(_ sender: Any) {
        self.backView.isHidden = true
    }
    @IBAction func stripePaymentInfoButtonPressed(_ sender: Any) {
        self.dataTableview.isHidden = false
        self.backView.isHidden = true
        
    }
    
    @objc func crossButtonPressed(sender:UIButton){
        self.dismiss(animated: true)
    }
   
    @objc func settlementFooterButtonPressed(sender:UIButton){
        self.dataTableview.isHidden = true
        self.backView.isHidden = false
    }
    
    @IBAction func SettlementListClicked(_ sender: Any) {
       
        self.backView.isHidden = false
        
    }
    
    @IBAction func settlementButtonPressed(_ sender: UIButton) {
        
        if let setttleObject = self.settlementData
        {
            sender.isEnabled = false
            SKActivityIndicator.show()
            WebServiceManager.sharedInstance.settlePayment(store_id: Singleton.sharedInstance.retailerData.storeId ?? "", currency: setttleObject.currency ?? "", amount: setttleObject.totalAmount ?? 0, account_id: setttleObject.accountId ?? "", OrderID: self.stringOrderID) {settlementData1, msg, status in
                //self.isLodinData = false
                sender.isEnabled = true
              
               SKActivityIndicator.dismiss()
                
               
                if status == "1"{
                    self.settlementData = nil
                    self.displayTransactionList()
                    self.getStripeSettlement()
                    let alert = UIAlertController(style: .alert, title: "Success", message: msg)
                    alert.addAction(title: "OK") { [unowned self] action in
                        //self.dismiss(animated: true)
                      
                        
                    }
                    self.present(alert, animated: true)
                }else{
                    let alert = UIAlertController(style: .alert, title: CommonConstant.Error, message: msg)
                    alert.addAction(title: "OK") { [unowned self] action in
                        self.dismiss(animated: true)
                    }
                    self.present(alert, animated: true)
                }
              }
        }
        }
    func getStripeSettlement(){
        self.settlebutton.isHidden = true
        self.staticTotalAmount.isHidden = true
        self.totalAmount.isHidden = true
        self.erroMessageLabel.isHidden = true
        self.buttonInfo.isEnabled = false
        self.settlmentButton.isHidden = true
        self.totalAmountConstant.isHidden = true
        SKActivityIndicator.show()
        WebServiceManager.sharedInstance.checkStripeTransactionListing() {settlementData1, msg, status in
            //self.isLodinData = false
            
            SKActivityIndicator.dismiss()
            
                if status == "1"{
                    self.settlementData = settlementData1
                    let currency =  Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? ""
                    if let totalAmount = self.settlementData?.totalAmount{
                        if let decimalAmount = Double(totalAmount) as? Double
                        {
                            let decimalAmount1 = decimalAmount/100
                            self.totalAmount.text = currency + " \(decimalAmount1)"
                        }
                    }
                    self.totalAmountValue.text = self.totalAmount.text
                    if let orderDetail = self.settlementData?.orderDetail{
                       
                        for object in orderDetail{
                            if self.stringOrderID == ""{
                                self.stringOrderID = object.id ?? ""
                            }else{
                                self.stringOrderID =  self.stringOrderID + ","
                                self.stringOrderID =  self.stringOrderID +  (object.id ?? "")
                            }
                            
                        }
                    }
                    self.totalAmountConstant.isHidden = false
                    self.settlebutton.isHidden = false
                    self.settlmentButton.isHidden = false
                    
                    self.staticTotalAmount.isHidden = false
                    self.totalAmount.isHidden = false
                    self.erroMessageLabel.isHidden = false
                    self.buttonInfo.isEnabled = true
                    self.erroMessageLabel.text = SettleMentControllerConstant.doYouSettlement
                    self.reloadTable()
                }else{
                    self.settlebutton.isHidden = true
                    self.noButton.setTitle("Ok", for: .normal)
                    self.staticTotalAmount.isHidden = true
                    self.totalAmount.isHidden = true
                    self.erroMessageLabel.isHidden = false
                    self.erroMessageLabel.text = msg
                    self.erroMessageList.text = msg
                    self.buttonInfo.isEnabled = false
                    
                    self.totalAmountConstant.text = ""
                    self.totalAmountValue.text = ""
                    self.settlmentButton.isHidden = true
                    self.totalAmountConstant.isHidden = true

                }
             
          }
        }
    func reloadTable(){
        self.dataTableview.dataSource = self
        self.dataTableview.delegate = self
        self.dataTableview.reloadData()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension PaymentSettlementPopUpViewController: UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
   }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settlementData?.orderDetail?.count ?? -1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettlementPaymentRowTableViewCell", for: indexPath) as? SettlementPaymentRowTableViewCell else { return UITableViewCell.init() }
       
        
        
              cell.srLabel.font =  UIFont().MontserratRegular(size: 13.0)
              cell.orderIDLabel.font =  UIFont().MontserratMedium(size: 13.0)
        
        
            cell.dateAndTimeLabel.font =  UIFont().MontserratRegular(size: 13.0)
            cell.netAmountLabel.font =  UIFont().MontserratMedium(size: 13.0)
  
                  let currency =  Singleton.sharedInstance.retailerData?.selectedStoreCurrency ?? ""
        
              if let orderDetail = settlementData?.orderDetail{
                  let count = indexPath.row  + 1
                  cell.srLabel.text = "\(count)"
                  
                  if let id = orderDetail[indexPath.row].id{
                      cell.orderIDLabel.text = "\(id)"
                  }
                  if let amount = orderDetail[indexPath.row].amount{
                    cell.netAmountLabel.text = currency + " \(amount)"
                  }
                  
                  
                  if let paymentTime = orderDetail[indexPath.row].paymentTime{
                    cell.dateAndTimeLabel.text = "\(paymentTime)"
                  }
                 
            
          }
      
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettlementPaymentFooterTableViewCell") as? SettlementPaymentFooterTableViewCell else { return UITableViewCell.init() }
        
      
        if  let orderDetail = settlementData?.orderDetail{
            if  orderDetail.count == 0 {
                cell.srLabel.text = ""
                cell.orderIDLabel.text = ""
                cell.dateAndTimeLabel.text = ""
                cell.netAmountLabel.text = ""
            }else{
                cell.srLabel.text = SettleMentControllerConstant.SNo
                cell.orderIDLabel.text = SettleMentControllerConstant.OrderID
                cell.dateAndTimeLabel.text = SettleMentControllerConstant.DateTime
                cell.netAmountLabel.text = SettleMentControllerConstant.NetAmount
            }
        }else{
            
            cell.srLabel.text = ""
            cell.orderIDLabel.text = ""
            cell.dateAndTimeLabel.text = ""
            cell.netAmountLabel.text = ""
        }
        
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettlementTotalAmountFooterTableViewCell") as? SettlementTotalAmountFooterTableViewCell else { return UITableViewCell.init() }
         if  let arr = settlementData?.orderDetail
        {
              cell.titleLabel.font =  UIFont().MontserratBold(size: 17.0)
              cell.titleLabel.font =  UIFont().MontserratBold(size: 17.0)
              cell.titleLabel.text = "Total"
             cell.descriptionLabel.text = self.totalAmount.text
      }
       
        cell.headerButton.addTarget(self, action: #selector(crossButtonPressed(sender: )), for: .touchUpInside)
        Utility().roundCorner(view: cell.headerButton, borderWith: 0.0, borderColor: UIColor.clear, cornerRadius: 5.0)?
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 0.0
        if  let orderDetail = settlementData?.orderDetail{
            if  orderDetail.count == 0 {
                return 0.0
            }
        }else{
            return 0.0
        }
        
       return 80.0
    }
    */
    
}
