//
//  AddLogsViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/01/23.
//

import UIKit
import FTIndicator
class AddLogsViewController: UIViewController ,UITextFieldDelegate ,DropDownDelegate{
    //MARK: IBOUTLETS AND VARIABLES
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var txtViewAddComment: UITextView!
    @IBOutlet weak var txtStatus: UITextField!
    var selectedValue:String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var updateStatusLabel: UILabel!
    @IBOutlet weak var selectStatusLabel: UILabel!
    @IBOutlet weak var addStatusButton: UIButton!
    
    
    var dropdowns : [ManufacturingSubStatuslist]?
    
    var dropdowns_workOrder : [ManufacturingStatuslist]?
    
    var orderInfo : OrderInfo!
    var comingStatus = ""
    var statusDelegate : GetStatus?
    var paymentMethod = ""
    var userID = ""
    var oderID = ""
    var isFromStaus = ""
    
    var dealList:DealList?
    var salesOrderDetail:SalesOrderDetail?
    
    var isWorkOrderDetail = false
    var isSalesOrderDetail = true
    var manfacturingOrderListInfo:ManfacturingWorkOrderListInfo?
    
    
    //MARK: VIEW LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        txtStatus.text = comingStatus
        txtStatus.delegate = self
       
        
        titleLabel.font = UIFont().MontserratSemiBold(size: 17.0)
        updateStatusLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        
        selectStatusLabel.font = UIFont().MontserratRegular(size: 14.0)
        
        txtStatus.font = UIFont().MontserratRegular(size: 14.0)
        txtViewAddComment.font = UIFont().MontserratRegular(size: 14.0)
        addStatusButton.titleLabel?.font  = UIFont().MontserratSemiBold(size: 17.0)
        updateStatusLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        
        
        
        titleLabel.text = SaleOrderWorkFlowConstant.AddLogs
        var dealStatus = self.salesOrderDetail?.dealStatus ?? ""
        if self.isWorkOrderDetail{
            dealStatus = self.manfacturingOrderListInfo?.orderStatus ?? ""
        }
        updateStatusLabel.text = SaleOrderWorkFlowConstant.UpdateStatusFor + dealStatus
        selectStatusLabel.text = SaleOrderWorkFlowConstant.SelectStatus
        txtViewAddComment.placeholder = SaleOrderWorkFlowConstant.EnterComment
        addStatusButton.cornerRadius = 5.0
        
        
        
        getManufacturingStatus()
        showIndicator()
        txtStatus.text = comingStatus
    }
    //MARK: BUTTON ACTION
    @IBAction func buttonSubmit(_ sender: UIButton) {
        if txtStatus.text == ""{
            FTIndicator.showToastMessage(SaleOrderWorkFlowConstant.PleaseSelectStatus)
        }else if txtViewAddComment.text == ""{
            FTIndicator.showToastMessage(SaleOrderWorkFlowConstant.PleaseEnterComment)
        }else{
            updateOrderStatus(paymentMethod: paymentMethod, userID: userID, status: self.txtStatus.text ?? "", oderID: oderID)
        }
       
        
    }
    //MARK: FUNCTIONS
    //MARK:- ************UPDATE ORDER STATUS
    func updateOrderStatus(paymentMethod: String, userID: String, status: String, oderID: String){
        
        
        if self.isSalesOrderDetail{
            showIndicator()
            let dealSubStatus =  selectedValue
            let createBy = self.salesOrderDetail?.userId ?? ""
            let dealId = self.dealList?.dealId ?? ""
            let dealStatus = self.salesOrderDetail?.dealStatus ?? ""
            let refType = "COMMON_DEMO"
            let statusComment = self.txtViewAddComment.text ?? ""
            
        WebServiceManagerDeal.sharedInstance.addDealLogsAndWorkflow(dealSubStatus: dealSubStatus, createBy: createBy, dealId: dealId, refType: refType, statusComment: statusComment, dealStatus: dealStatus) { msg, status in
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
            
        }else if self.isWorkOrderDetail
        {
            let dealSubStatus =  selectedValue
            let createBy = self.manfacturingOrderListInfo?.userId ?? ""
            let orderId = self.manfacturingOrderListInfo?.orderId ?? ""
            let dealStatus = self.manfacturingOrderListInfo?.orderStatus ?? ""
            let refType = "ORDERS"
            let statusComment = self.txtViewAddComment.text ?? ""
            
            WebServiceManagerDeal.sharedInstance.addDealLogsAndWorkflow_workOrder(orderSubStatus: dealSubStatus, createBy: createBy, orderId: orderId, refType: refType, statusComment: statusComment, orderStatus: dealStatus) { msg, status in
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
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        if self.isSalesOrderDetail{
            let data = dropdowns
            let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus,isComingFromStatus: "Yes" ,type: .orderStatus, dropDownType: .defaultType, data: data ?? [], sender: self)
    //        drop.isComingFromStatus = self.isFromStaus
            drop.dropDownVC.delegate = self
        }
        else if self.isWorkOrderDetail{
            let data = dropdowns_workOrder
            let drop  = DropdownPopUp(title: InventoryViewControllerConstant.SelectStatus,isComingFromStatus: "Yes" ,type: .orderStatus, dropDownType: .defaultType, data: data ?? [], sender: self)
    //        drop.isComingFromStatus = self.isFromStaus
            drop.dropDownVC.delegate = self
        }
    }

    //MARK:- ************GET ORDER STATUS
    func getManufacturingStatus(){
        
        if self.isSalesOrderDetail{
            let dealStatus = self.salesOrderDetail?.dealStatus ?? ""
           
            WebServiceManagerDeal.sharedInstance.getManufacturingStatus(role:dealStatus) { orderStatus, msg, status in
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
       else if self.isWorkOrderDetail{
          let  dealStatus  = self.manfacturingOrderListInfo?.orderStatus ?? ""
           
           WebServiceManagerDeal.sharedInstance.getManufacturingStatus_WorkOrder(role:dealStatus) { orderStatus, msg, status in
               self.hideIndicator()
               if status == "1"{
                   self.dropdowns_workOrder = orderStatus
                   
                   if self.orderInfo != nil{
                   }
               }else{
                   FTIndicator.showToastMessage(msg!)
               }
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
                
                selectedValue = value?.value ?? ""
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
