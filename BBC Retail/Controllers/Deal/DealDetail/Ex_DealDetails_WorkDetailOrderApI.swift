//
//  Ex_DealDetails_WorkDetailOrderApI.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/01/23.
//

import Foundation
import FTIndicator
extension DealDetailsVC{
    
    
    //MARK:- ******  Work  Order   ********************
    func initWorkOrderUI(){
        self.updateWorkOrderDealUI()
        self.tappedOrderDetail_Basicfunc()
        refreshWorkOrder()
    }
    fileprivate func updateWorkOrderDealUI() {
        btn_deal.titleLabel?.font = UIFont().MontserratRegular(size: 15.0)
        btn_store.titleLabel?.font = UIFont().MontserratRegular(size: 15.0)
        btn_user.titleLabel?.font = UIFont().MontserratRegular(size: 15.0)
        btn_workFlow.titleLabel?.font = UIFont().MontserratRegular(size: 15.0)
        btn_deal.setTitle(DetailDealListConstant.Deal, for: .normal)
        btn_store.setTitle(DetailDealListConstant.Store, for: .normal)
        btn_user.setTitle(DetailDealListConstant.Logs, for: .normal)
        btn_workFlow.setTitle(DetailDealListConstant.WorkFlow, for: .normal)
        
        self.dealIdLabelContant.text = DealListConstant.DealId
        self.serviceLabelContant.text = DetailDealListConstant.ServiceGroup
        self.productNameLabelContant.text = DetailDealListConstant.ProductName
        self.quantityLabelContant.text = DetailDealListConstant.Quantity
        self.amountLabelContant.text = DetailDealListConstant.Amount
        self.storeLabelContant.text = DetailDealListConstant.StoreName
      
        self.dealIdLabelContant.font = UIFont().MontserratSemiBold(size: 14.0)
        self.dealIdLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        self.titleLabel.font = UIFont().MontserratSemiBold(size: 14.0)
        
        
        self.userNameLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.emailLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.phoneLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.serviceLabel.font = UIFont().MontserratMedium(size: 13.0)
        
        self.productNameLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.quantityLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.amountLabel.font = UIFont().MontserratMedium(size: 13.0)
        self.storeLabel.font = UIFont().MontserratMedium(size: 13.0)
        
        
       
        self.serviceLabelContant.font = UIFont().MontserratMedium(size: 13.0)
        self.productNameLabelContant.font = UIFont().MontserratMedium(size: 13.0)
        self.quantityLabelContant.font = UIFont().MontserratMedium(size: 13.0)
        self.amountLabelContant.font = UIFont().MontserratMedium(size: 13.0)
        self.storeLabelContant.font = UIFont().MontserratMedium(size: 13.0)
        
    }
    func refreshWorkOrder(){
        
        self.geWorkOrderDetail()
        
        let seconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.getStoreInfoDetail()
        }
        let seconds2 = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
            // Put your code which should be executed with a delay here
            self.getLogList_workOrder()
        }
        let seconds3 = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds3) {
            // Put your code which should be executed with a delay here
            self.getWrokFlow_WorkOrder()
        }
    }
    func deActivateWorkOrder(){
        self.btn_OrderDetail_Basic.isHidden = true
        self.btn_OrderDetail_Order.isHidden = true
    }
    func geWorkOrderDetail(){
        showIndicator()
        WebServiceManagerDeal.sharedInstance.getManufacturingOrderDetailById(orderId: self.dealWorkOrderList?.orderId ?? "") { obj, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.manfacturingWorkOrderListInfo = obj
                self.tbl_workOrderDetail.reloadData()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
        
    }
    func getLogList_workOrder(){
        showIndicator()
        WebServiceManagerDeal.sharedInstance.getLogList_WorkOrder(dealId: self.dealWorkOrderList?.orderId ?? "") { logArr, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.logArr = logArr
                self.tbl_StoreDetails.reloadData()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
        
    }
    func getWrokFlow_WorkOrder(){
        showIndicator()
        
        WebServiceManagerDeal.sharedInstance.getWorkFlow_WorkOrder(order_id: self.dealWorkOrderList?.orderId ?? "") { workArr, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.workFlowListArr = workArr ?? []
                self.tbl_workflowList.reloadData()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
        
    }
    
 
}
