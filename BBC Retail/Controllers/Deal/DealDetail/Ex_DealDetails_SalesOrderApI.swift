//
//  Ex_DealDetails_SalesOrderApI.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/01/23.
//

import Foundation
import FTIndicator
extension DealDetailsVC{
    //MARK:- ****** Sales Order   ********************
    func initSalesOrderUI(){
        self.handleSelectedDealButton()
        self.updateSaleOrderDealUI()
        multipleButtonCornerBgColorSet(btn1: btn_deal, btn2: btn_store, btn3: btn_user, btn4: btn_workFlow, boarderWidth: 1.0, boarderColor: DEAL_DETAIL_BTN_BOARDER_COLOR, cornerRadius: 5.0, btn1_bgColor: DEAL_DETAIL_BTN_SLECT_BG_COLOR, btn2_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn3_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn4_bgColor: DEAL_DETAIL_BTN_DESLECT_BG_COLOR, btn1_text_Color: .white, btn2_text_Color: .black, btn3_text_Color: .black, btn4_text_Color: .black)
        self.refreshSalesOrder()
        
    }
    func refreshSalesOrder(){
        self.getDealDetail()
        let seconds = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            // Put your code which should be executed with a delay here
            self.getStoreInfoDetail()
        }
        let seconds2 = 0.2
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds2) {
            // Put your code which should be executed with a delay here
            self.getLogList()
        }
        let seconds3 = 0.3
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds3) {
            // Put your code which should be executed with a delay here
            self.getWrokFlow()
        }
    }
    fileprivate func updateSaleOrderDealUI() {
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
    func deactivateSalesOrder(){
        self.btn_deal.isHidden = true
        view_BGDeal.isHidden = true
        view_BGUser.isHidden = true
    }
    
    func udpateValueDealValues(){
        self.dealIdLabel.text = self.salesOrderDetail?.dealId ?? ""
        self.titleLabel.text = self.salesOrderDetail?.salesOrderType ?? ""
        var userName = self.salesOrderDetail?.userFirstName ?? ""
        var lastName = self.salesOrderDetail?.userLastName ?? ""
        self.userNameLabel.text = userName + " " + lastName
        self.emailLabel.text = self.salesOrderDetail?.userEmail ?? ""
        self.phoneLabel.text = self.salesOrderDetail?.userMobile ?? ""
        self.serviceLabel.text = self.salesOrderDetail?.serviceGroup ?? ""
        self.productNameLabel.text = self.salesOrderDetail?.productName ?? ""
        self.quantityLabel.text = self.salesOrderDetail?.quantity ?? ""
        self.amountLabel.text = self.salesOrderDetail?.amount ?? ""
        self.storeLabel.text = self.salesOrderDetail?.storeName ?? ""
        
    }
    
    
    //MARK:- ****** get Deal Detail  ********************
    func getDealDetail(){
        showIndicator()
        WebServiceManagerDeal.sharedInstance.getmanufacturingDealDetail(dealId: self.dealList?.dealId ?? "") { dealDetail, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.salesOrderDetail = dealDetail
                self.udpateValueDealValues()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
    }
    func getStoreInfoDetail(){
        showIndicator()
        var storeID =    self.dealList?.storeId ?? ""
        if self.isWorkOrderDetail
        {
            storeID = self.dealWorkOrderList?.storeId ?? ""
        }
        WebServiceManagerDeal.sharedInstance.getStoreInfoDetail(dealId: storeID) { dealDetail, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.storeInfo = dealDetail
                self.tbl_StoreDetails.reloadData()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
        
    }
    func getLogList(){
        showIndicator()
        
        WebServiceManagerDeal.sharedInstance.getLogList(dealId: self.dealList?.dealId ?? "") { logArr, msg, status in
            self.hideIndicator()
            if status == "1" {
                self.logArr = logArr
                self.tbl_workflowList.reloadData()
            }
            else {
                FTIndicator.showToastMessage(msg)
               // self.updateNoData(message: msg)
            }
            
          }
        
    }
    
    func getWrokFlow(){
        showIndicator()
        
        WebServiceManagerDeal.sharedInstance.getWorkFlow(dealId: self.dealList?.dealId ?? "") { workArr, msg, status in
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
