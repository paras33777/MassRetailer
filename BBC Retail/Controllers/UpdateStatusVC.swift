//
//  UpdateStatusVC.swift
//  BBC Retail
//
//  Created by Himanshu on 27/10/22.
//

import UIKit
import FTIndicator
//MARK: PROTOCOL
protocol GetStatus{
    func changeStatus()
}
class UpdateStatusVC: UIViewController,UITextFieldDelegate ,DropDownDelegate{
    //MARK: IBOUTLETS AND VARIABLES
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtViewAddComment: UITextView!
    @IBOutlet weak var txtStatus: UITextField!
    var dropdowns : [OrderStatusType]?
    var orderInfo : OrderInfo!
    var comingStatus = ""
    var statusDelegate : GetStatus?
    var paymentMethod = ""
    var userID = ""
    var oderID = ""
    var isFromStaus = ""
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        txtStatus.text = comingStatus
        txtStatus.delegate = self
        txtViewAddComment.placeholder = "Add comment"
        getOrderStatus()
        showIndicator()
        txtStatus.text = comingStatus
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonSubmit(_ sender: UIButton) {
        updateOrderStatus(paymentMethod: paymentMethod, userID: userID, status: self.txtStatus.text ?? "", oderID: oderID)
        
    }
    //MARK: FUNCTIONS
    //MARK:- ************UPDATE ORDER STATUS
    func updateOrderStatus(paymentMethod: String, userID: String, status: String, oderID: String){
        showIndicator()
        WebServiceManager.sharedInstance.updateOrderStatus(paymentMethod: paymentMethod, userID: userID, status: status, oderID: oderID){ msg, status in
            self.hideIndicator()
            if status == "1"{
               
                // self.orderStatus = orderStatus
                if let del = self.statusDelegate{
                    self.dismiss(animated: false)
                    del.changeStatus()
                }
                FTIndicator.showToastMessage(msg!)
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        let data = dropdowns
        let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus,isComingFromStatus: "Yes" ,type: .orderStatus, dropDownType: .defaultType, data: data ?? [], sender: self)
//        drop.isComingFromStatus = self.isFromStaus
        drop.dropDownVC.delegate = self
        
    }
    //MARK:- ************GET ORDER STATUS
    func getOrderStatus(){
        WebServiceManager.sharedInstance.getOrderStatus { orderStatus, msg, status in
            self.hideIndicator()
            if status == "1"{
                self.dropdowns = orderStatus
                
                if self.orderInfo != nil{
                }
            }else{
                FTIndicator.showToastMessage(msg!)
            }
        }
    }
    func returnSelectedValue(_ value: DropDownModel?, dataType: DataType, multiSelectionArr: [DropDownModel]) {
        
        switch dataType {
        case .orderStatus:
            print(value?.name ?? "")
            if (value?.name ?? "") == ""{
                
            }else{
                self.txtStatus.text = value?.name ?? ""
            }
        default: break
        }
        
    }
    //MARK:- BUTTON ACTION TOUCH
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        let touch = touches.first
        if touch?.view == self.backView { self.dismiss(animated: false, completion: nil) }
    }
}
