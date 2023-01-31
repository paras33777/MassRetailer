//
//  Ex_DealDetail_TableView.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 10/01/23.
//

import Foundation

import UIKit
import FTIndicator
//MARK :- ********** TABLE VIEW DELEGATE  ******
extension DealDetailsVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isSalesOrderDetail{
            if tableView == self.tbl_StoreDetails{
                return 1
            }
            else if tableView == self.tbl_workflowList && self.isLogs{
                return self.logArr?.count > 0 ?  1 : 0
               
            }
            else if tableView == self.tbl_workflowList && self.isWorkFlow{
                return self.workFlowListArr.count > 0 ?  self.workFlowListArr.count + 1 : 0
                
            }
        }
        if self.isWorkOrderDetail{
            if isWorkOrderDetail_Basic && tableView == self.tbl_workOrderDetail{
                return 1
            }
            if isWorkOrderDetail_OrderDetail && tableView == self.tbl_workOrderDetail{
                return 1
            }
            if tableView == self.tbl_StoreDetails{
                return 1
            }
            else if tableView == self.tbl_workflowList && self.isLogs{
                let count = self.logArr?.count ?? 0
                return count > 0 ?  1 : 1
               
            }
            else if tableView == self.tbl_workflowList && self.isWorkFlow{
                return self.workFlowListArr.count > 0 ?  self.workFlowListArr.count + 1 : 0
            }
            
        }
        
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.isSalesOrderDetail{
            if tableView == self.tbl_StoreDetails{
                return nil
            }
       else if tableView == self.tbl_workflowList && self.isLogs{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsSectionTableViewCell") as! SalesOrderLogsSectionTableViewCell
            cell.titleLabelConstant.text = DealListConstant.DealId
            cell.titleLabel.text = self.salesOrderDetail?.dealId ?? ""
           
            cell.titleLabel.font =  UIFont().MontserratMedium(size: 14.0)
            cell.titleLabelConstant.font =  UIFont().MontserratMedium(size: 14.0)
            cell.addLogButton.setTitle( DetailDealLogConstant.AddLogs, for: .normal)
            cell.addLogButtonHeight.constant = 40
           if self.isAddButton(){
               cell.addLogButtonHeight.constant = 40
               
           }else{
               cell.addLogButtonHeight.constant = 0
           }
           cell.addLogButton.layer.masksToBounds = true
           cell.addLogButton.layer.cornerRadius = 5.0
           cell.addLogButton.addTarget(self, action: #selector(self.addLogButtonPressed), for: .touchUpInside)
            
            return cell
        }else  if tableView == self.tbl_workflowList && self.isWorkFlow{
            if section == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsSectionTableViewCell") as! SalesOrderLogsSectionTableViewCell
                cell.titleLabelConstant.text = DealListConstant.DealId
                cell.titleLabel.text = self.salesOrderDetail?.dealId ?? ""
                
                cell.titleLabel.font =  UIFont().MontserratMedium(size: 14.0)
                cell.titleLabelConstant.font =  UIFont().MontserratMedium(size: 14.0)
                cell.addLogButtonHeight.constant = 0
                return cell
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaleWorkFlowSectionTableViewCell") as! SaleWorkFlowSectionTableViewCell
            if section == 1 {
                cell.top_Line.isHidden = true
            }else{
                cell.top_Line.isHidden = false
            }
            if section == self.workFlowListArr.count{
                cell.bottom_Line.isHidden = true
            }else{
                cell.bottom_Line.isHidden = false
            }
            cell.workFlow = self.workFlowListArr[section - 1]
            cell.updateUI()
            return cell
        }
        }
       else  if self.isWorkOrderDetail
        {
            if (isWorkOrderDetail_Basic || isWorkOrderDetail_OrderDetail) && tableView == self.tbl_workOrderDetail{
                return nil
            }
            else if tableView == self.tbl_workflowList && self.isLogs{
                 let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsSectionTableViewCell") as! SalesOrderLogsSectionTableViewCell
                 cell.titleLabelConstant.text = DealListConstant.Orderid
                   cell.titleLabel.text = self.manfacturingWorkOrderListInfo?.orderId ?? ""
                
                 cell.titleLabel.font =  UIFont().MontserratMedium(size: 14.0)
                 cell.titleLabelConstant.font =  UIFont().MontserratMedium(size: 14.0)
                cell.addLogButton.setTitle( DetailDealLogConstant.AddLogs, for: .normal)
                if self.isAddButton(){
                    cell.addLogButtonHeight.constant = 40
                }else{
                    cell.addLogButtonHeight.constant = 0
                }
                cell.addLogButton.layer.masksToBounds = true
                cell.addLogButton.layer.cornerRadius = 5.0
                cell.addLogButton.addTarget(self, action: #selector(self.addLogButtonPressed), for: .touchUpInside)
                 return cell
             }else  if tableView == self.tbl_workflowList && self.isWorkFlow{
                 
                 if section == 0{
                     let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsSectionTableViewCell") as! SalesOrderLogsSectionTableViewCell
                     cell.titleLabelConstant.text = DealListConstant.Orderid
                    cell.titleLabel.text = self.manfacturingWorkOrderListInfo?.orderId ?? ""
                     cell.titleLabel.font =  UIFont().MontserratMedium(size: 14.0)
                     cell.titleLabelConstant.font =  UIFont().MontserratMedium(size: 14.0)
                     cell.addLogButtonHeight.constant = 0
                     return cell
                 }
                 let cell = tableView.dequeueReusableCell(withIdentifier: "SaleWorkFlowSectionTableViewCell") as! SaleWorkFlowSectionTableViewCell
                 if section == 1 {
                     cell.top_Line.isHidden = true
                 }else{
                     cell.top_Line.isHidden = false
                 }
                 if section == self.workFlowListArr.count{
                     cell.bottom_Line.isHidden = true
                 }else{
                     cell.bottom_Line.isHidden = false
                 }
                 cell.workFlow = self.workFlowListArr[section - 1]
                 cell.updateUI()
                 return cell
             }
            
        }
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.isSalesOrderDetail{
            if tableView == self.tbl_StoreDetails{
                return 0.0
            }
        else if tableView == self.tbl_workflowList && self.isLogs{
            return UITableView.automaticDimension
        }
        if tableView == self.tbl_workflowList && self.isWorkFlow{
            return UITableView.automaticDimension
        }
        }
        if self.isWorkOrderDetail{
            if (isWorkOrderDetail_Basic || isWorkOrderDetail_OrderDetail) && tableView == self.tbl_workOrderDetail{
                 return UITableView.automaticDimension
            }
            else if tableView == self.tbl_workflowList && self.isLogs{
                return UITableView.automaticDimension
            }
            else if tableView == self.tbl_workflowList && self.isWorkFlow{
                return UITableView.automaticDimension
            }
        }
        return 0.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isSalesOrderDetail{
            if tableView == self.tbl_StoreDetails{
                return 1
            }
           else if tableView == self.tbl_workflowList && self.isLogs{
                 return logArr?.count ?? 0
            }
           else if tableView == self.tbl_workflowList && self.isWorkFlow{
               if section == 0{
                   return 0
               }
                let worflow =  self.workFlowListArr[section - 1]
                   
                   if worflow.commentsecond == "" || worflow.commentsecond == nil
                   {
                       return 1
                   }
                   
               
                return 2
                   
            }
            
        }
        if self.isWorkOrderDetail{
            if isWorkOrderDetail_Basic || isWorkOrderDetail_OrderDetail && (tableView == tbl_workOrderDetail){
                if self.manfacturingWorkOrderListInfo  == nil{
                    return 0
                }
                return 1
            }
            else if tableView == self.tbl_workflowList && self.isLogs{
             return logArr?.count ?? 0
             }
            else  if tableView == self.tbl_workflowList && self.isWorkFlow{
                if section == 0{
                    return 0
                }
                   let worflow =  self.workFlowListArr[section - 1]
                    if worflow.commentsecond == "" || worflow.commentsecond == nil
                    {
                        return 1
                    }
                    
                
                 return 2
               }
            else  if tableView == self.tbl_StoreDetails{
                return 1
            }
           /* else if tableView == tbl_workflowList{
                         return self.manfacturingOrderListInfo?.count ?? 0
               }*/
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isSalesOrderDetail{
            if tableView == self.tbl_StoreDetails{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderSalesInfoCell", for: indexPath) as! SalesOrderSalesInfoCell
                cell.storeInfo = self.storeInfo
                cell.updateSaleOrder_store_UI()
                cell.dealId = self.salesOrderDetail?.dealId ?? ""
                cell.udpateStoreValue_SaleOrder()
                return cell
            }
           else if tableView == self.tbl_workflowList && self.isLogs{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsTableViewCell", for: indexPath) as! SalesOrderLogsTableViewCell
               cell.logsList = self.logArr?[indexPath.row]
              
            cell.updateFont()
            return cell
        } else  if tableView == self.tbl_workflowList && self.isWorkFlow{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaleWorkFlowRowTableViewCell") as! SaleWorkFlowRowTableViewCell
            cell.workflow =  self.workFlowListArr[indexPath.section - 1]
            cell.row = indexPath.row
            if indexPath.section == self.workFlowListArr.count{
                cell.section_Line.isHidden = true
            }else{
                cell.section_Line.isHidden = false
            }
            cell.updateUI()
            return cell
        }
        if tableView == tbl_workflowList{
            let cell = tableView.dequeueReusableCell(withIdentifier: "workFlowListCell", for: indexPath) as! workFlowListCell
            
            //MARK:- DATA SHOW
            /*
            cell.lbl_OrderResponse.text = workFlowListArr[indexPath.row].order_response
            cell.lbl_OrderStatus.text = workFlowListArr[indexPath.row].order_status
            cell.lbl_name.text = workFlowListArr[indexPath.row].name
            cell.img_status.image = UIImage(named:  workFlowListArr[indexPath.row].status_image ?? "")
            cell.lbl_date.text = workFlowListArr[indexPath.row].date
            
            //=== STATUS AND RESPONSE LABEL COLOR SET ========
            cell.lbl_OrderResponse.textColor =  UIColor(hexString: workFlowListArr[indexPath.row].textColor ?? "ADB2B9")
            cell.view_BGStatus.backgroundColor = UIColor(hexString: workFlowListArr[indexPath.row].textColor ?? "ADB2B9")
            
            if workFlowListArr[indexPath.row].name == ""{
                cell.lbl_OrderStatus.textColor = UIColor(hexString: "ADB2B9")
                cell.top_orderRespnse.constant = 20
                cell.top_Respnse.constant = 34
            }else{
                cell.top_orderRespnse.constant = 0
                cell.top_Respnse.constant = 14
            }
            //MARK:- VIEW LINE PATH TOP AND BOTTOM HIDE ===
            if workFlowListArr[indexPath.row].top_lineHide == true{
                cell.view_topLine.isHidden = true
            }else{
                cell.view_topLine.isHidden = false
            }
            if workFlowListArr[indexPath.row].bottom_lineHide == true{
                cell.view_bottomLine.isHidden = true
            }else{
                cell.view_bottomLine.isHidden = false
            }
             */
            
            return cell
        }
        }
        if self.isWorkOrderDetail{
            if isWorkOrderDetail_Basic && tableView == self.tbl_workOrderDetail{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderBasicTableViewCell", for: indexPath) as! WorkOrderBasicTableViewCell
                cell.manfacturingWorkOrderListInfo = self.manfacturingWorkOrderListInfo
                cell.updateUI()
                return cell
            }else if tableView == self.tbl_StoreDetails{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderSalesInfoCell", for: indexPath) as! SalesOrderSalesInfoCell
                cell.storeInfo = self.storeInfo
                cell.updateSaleOrder_store_UI()
                cell.dealId = self.manfacturingWorkOrderListInfo?.dealId ?? ""
                cell.orderId = self.manfacturingWorkOrderListInfo?.orderId ?? ""
                cell.udpateStoreValue_WorkOrder()
                return cell
            }
           else if isWorkOrderDetail_OrderDetail  && tableView == self.tbl_workOrderDetail{
                let cell = tableView.dequeueReusableCell(withIdentifier: "WorkOrderORderTableViewCell", for: indexPath) as! WorkOrderORderTableViewCell
               cell.manfacturingWorkOrderListInfo = self.manfacturingWorkOrderListInfo
                cell.updateUI()
                return cell
            }else if tableView == self.tbl_workflowList && self.isLogs{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SalesOrderLogsTableViewCell", for: indexPath) as! SalesOrderLogsTableViewCell
                
                cell.logsList = self.logArr?[indexPath.row]
                cell.updateFont()
                return cell
            }else  if tableView == self.tbl_workflowList && self.isWorkFlow{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SaleWorkFlowRowTableViewCell") as! SaleWorkFlowRowTableViewCell
                cell.workflow =  self.workFlowListArr[indexPath.section - 1]
                cell.row = indexPath.row
                
                if indexPath.section == self.workFlowListArr.count{
                    cell.section_Line.isHidden = true
                }else{
                    cell.section_Line.isHidden = false
                }
                
                
                cell.updateUI()
                return cell
            }
          
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
  @objc func addLogButtonPressed(){
      let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddLogsViewController") as! AddLogsViewController
      vc.modalPresentationStyle = .overCurrentContext
     // vc.paymentMethod = orderInfo.paymentStatus ?? ""
     // vc.userID = orderInfo.userId
    //  vc.oderID = orderInfo.orderId ?? ""
   //   vc.comingStatus = self.labelOrderStatus.text ?? ""
      vc.statusDelegate = self
      vc.isFromStaus = "Yes"
      vc.dealList = self.dealList
      vc.salesOrderDetail = self.salesOrderDetail
      vc.manfacturingOrderListInfo = self.manfacturingWorkOrderListInfo
      vc.isWorkOrderDetail = self.isWorkOrderDetail
      vc.isSalesOrderDetail = self.isSalesOrderDetail
      self.present(vc, animated: false,completion: nil)
    }
    
    func isAddButton() ->Bool{
        var dealStatus = self.dealList?.dealStatus ?? ""
        var dealSubStatus = self.dealList?.dealSubStatus ?? ""
        
        if self.isWorkOrderDetail{
            dealStatus = self.dealWorkOrderList?.status ?? ""
            dealSubStatus = self.dealWorkOrderList?.subStatus ?? ""
        }
        
        
        let access = Singleton.sharedInstance.retailerData.access?.lowercased()
        dealStatus = dealStatus.lowercased()
        
        dealSubStatus = dealSubStatus.lowercased()
        
        if (access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "pending"
        {
            return true
            
        }else if (access == "store" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "store" &&  dealSubStatus == "in progress" {
            return true
        }else if (access == "production" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "production" &&  dealSubStatus == "in progress" {
            return true
        }
        else if (access == "qa" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "qa" &&  dealSubStatus == "in progress" {
            return true
        }
        else if (access == "accounting" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "accounting" &&  dealSubStatus == "in progress"{
            return true
        }
        else if (access == "packaging" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "packaging" &&  dealSubStatus == "in progress"{
            return true
        }
        else if (access == "dispatch" || access == "retailer" || access == "owner" || access == "manager" || access == "superadmin" ) && dealStatus == "dispatch" &&  dealSubStatus == "in progress"{
            return true
        }
        return false
        
    }
    
}

extension DealDetailsVC: GetStatus{
    func changeStatus() {
        if self.isSalesOrderDetail{
            self.refreshSalesOrder()
        }else if isWorkOrderDetail{
            self.refreshWorkOrder()
        }
       
    }
}
