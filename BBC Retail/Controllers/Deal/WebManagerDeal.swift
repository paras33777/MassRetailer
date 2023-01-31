//
//  WebManagerDeal.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/01/23.
//

import Foundation
import UIKit
class WebServiceManagerDeal {
    static let sharedInstance = WebServiceManagerDeal()
    let userDefault = UserDefaults.standard
    let keyChainAccess = KeychainAccess()
    
    
    //MARK: ******************GET DEALS LIST******************
    func getDealsList(page: String,commonFilter:String,  completionHandler closure: @escaping([DealList]?, String, String, Int?, Int?) -> Void) {
        let param = [
            "page":page,
            "storeId": Singleton.sharedInstance.retailerData.storeId ?? "",
            "commonFilter":commonFilter,
            "perLimit": 10
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getDealsList, parameters: param) { data, error in
            guard let data: Base = data else { return }
            closure(data.result?.dealList, data.msg!, data.status!, data.result?.totalCount, data.result?.totalpage)
        }
    }
    
    
    //MARK: ******************GET DEALS Details******************
    func getStoreInfoDetail(dealId:String,completionHandler closure: @escaping(StoreInfo?,String?,String?) -> Void) {
        let params = [
            "store_id": dealId
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreDetailedInfo, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.storeInfo,data.msg!,data.status)
        }
    }
    //MARK: ******************GET DEALS Details******************
    func getSalesOrderDeal(dealId:String,completionHandler closure: @escaping(StoreInfo?,String?,String?) -> Void) {
        let params = [
            "dealId": dealId
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreDetailedInfo, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.storeInfo,data.msg!,data.status)
        }
    }
    //MARK: ******************GET DEALS Details******************
    func getmanufacturingDealDetail(dealId:String,completionHandler closure: @escaping(SalesOrderDetail?,String?,String?) -> Void) {
        let params = [
            "dealId": dealId,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.manufacturingDealDetail, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.salesOrderDetail,data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET LogsList******************
    func getLogList(dealId:String,completionHandler closure: @escaping([LogsList]?,String?,String?) -> Void) {
        let params = [
            "REF_ID": dealId,
            "REF_TYPE": "COMMON_DEMO",
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRetailerLogs, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.logsList,data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************GET getWorkFlow******************
    func getWorkFlow(dealId:String,completionHandler closure: @escaping([WorkFlow]?,String?,String?) -> Void) {
        let params = [
            "demo_id": dealId
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.fetchManufacturingWorkflowData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result2?.workFlow,data.msg!,data.status)
        }
    }
    //MARK: ******************GET getWorkFlow Order******************
    func getWorkFlow_WorkOrder(order_id:String,completionHandler closure: @escaping([WorkFlow]?,String?,String?) -> Void) {
        let params = [
            "order_id": order_id
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.fetchManufacturingWorkflowData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result2?.workFlow,data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET LogsList Work Order******************
    func getLogList_WorkOrder(dealId:String,completionHandler closure: @escaping([LogsList]?,String?,String?) -> Void) {
        let params = [
            "REF_ID": dealId,
            "REF_TYPE": "ORDERS",
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRetailerLogs, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.logsList,data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************GET ORDER STATUS******************
    func getManufacturingStatus(role:String = "Production",completionHandler closure: @escaping([ManufacturingSubStatuslist]?,String?,String?) -> Void) {
        let params = [
            "role":role,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingStatus, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.manufacturingSubStatuslist
            
            
            closure(dropdowns,data.msg,data.status)
        }
    }
    //MARK: ******************GET ORDER STATUS Work Order******************
    func getManufacturingStatus_WorkOrder(role:String = "Production",completionHandler closure: @escaping([ManufacturingStatuslist]?,String?,String?) -> Void) {
        let params = [
            "role":role,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingStatus, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.manufacturingStatuslist
            
            closure(dropdowns,data.msg,data.status)
        }
    }
    
    //MARK: ******************UPDATE AddDealLogsAndWorkflow API******************
    func addDealLogsAndWorkflow(dealSubStatus:String,createBy:String,dealId:String,refType:String,statusComment:String,dealStatus:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "dealSubStatus":dealSubStatus,
            "createBy":createBy,
            "dealId":dealId,
            "refType":refType,
            "statusComment": statusComment,
            "dealStatus":dealStatus,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addDealLogsAndWorkflow, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************UPDATE AddDealLogsAndWorkflow Work Oder Detail API******************
    func addDealLogsAndWorkflow_workOrder(orderSubStatus:String,createBy:String,orderId:String,refType:String,statusComment:String,orderStatus:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "orderSubStatus":orderSubStatus,
            "createBy":createBy,
            "orderId":orderId,
            "refType":refType,
            "statusComment": statusComment,
            "orderStatus":orderStatus,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addOrderLogsAndWorkflow, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET Work Order LIST******************
    func getWorkOrderList(page: String,commonFilter:String,  completionHandler closure: @escaping([WorkOrderList]?, String, String, Int?, Int?) -> Void) {
        let param = [
            "page":page,
            "storeId": Singleton.sharedInstance.retailerData.storeId ?? "",
            "commonFilter":commonFilter,
            "perLimit": 10
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingOrderList, parameters: param) { data, error in
            guard let data: Base = data else { return }
            closure(data.result?.dealWorkOrderList, data.msg!, data.status!, data.result?.totalCount, data.result?.totalpage)
        }
    }
    //MARK: ******************GET LogsList Work Order******************
    func getManufacturingOrderDetailById(orderId:String,completionHandler closure: @escaping(ManfacturingWorkOrderListInfo?,String?,String?) -> Void) {
        let params = [
            "orderId": orderId,
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingOrderDetailById, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.workOrderInfo,data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************addProductSubSkill******************
    func addProductSubSkill(subSkill:String,price:String,completionHandler closure: @escaping(ManfacturingWorkOrderListInfo?,String?,String?) -> Void) {
        let params = [
            "subSkill": subSkill,
            "price": price,
            "storeId" :Singleton.sharedInstance.retailerData.storeId!,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addProductSubSkill, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.workOrderInfo,data.msg!,data.status)
        }
    }
    //MARK: ******************getProductSubSkill******************
    func getAllSubSkill(completionHandler closure: @escaping([SubSkillList]?,String?,String?) -> Void) {
        let params = [
            "storeId" :Singleton.sharedInstance.retailerData.storeId!,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getAllSubSkill, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.allSubSkillList,data.msg!,data.status)
        }
    }
    //MARK: ******************GET PRODUCT DETAILS BY ID ******************
    func getProductDetailsById_Manfacturing(product_id:String,completionHandler closure: @escaping(ProductDetail?,String?,String?) -> Void) {
        let params = [
            "productId": product_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingProductsDetail, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productDetail,data.msg!,data.status)
        }
    }
   
    //MARK: ****************** Add Manufacturing Product ******************
    func addProduct(productImage:UIImage,name:String,shortDescr:String,currencyType:String,mainID:String,childID:String,grandChildID:String,barcodeId:String,subSkills:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "retailerId" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "storeId" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "productName":name,
            "productShortDescription":shortDescr,
            "currencyType":currencyType,
            "categoryId":mainID,
            "childCategoryId":childID,
            "grandChildCategoryId":grandChildID,
            "productAvatar":productImage,
            "barcodeId":barcodeId,
            "subSkills":subSkills,
 
        ] as [String : Any]
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url: EndPoint.addManufacturingProduct, image: productImage, fileParameter:  "productAvatar", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ****************** EDIT  PRODUCT ******************
    func editProduct_manfacturing(productImage:UIImage,grandChildID:String,name:String,shortDescr:String,currencyType:String,mainID:String,childID:String,productID:String,subSkills:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            
            "productName" :name,
            "productShortDescription":shortDescr,
            "storeId" :Singleton.sharedInstance.retailerData.storeId ?? "",
            "retailerId": Singleton.sharedInstance.retailerData.RetailerId!,
            "productId":productID,
            "currencyType":currencyType,
            "categoryId":mainID,
            "childCategoryId":childID,
            "grandChildCategoryId":grandChildID,
            "COURSE_AVTAR":productImage,
        ] as [String : Any]
 
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url: EndPoint.updateManufacturingProduct, image: productImage, fileParameter:  "COURSE_AVTAR", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    
    //MARK: ******************GET PRODUCT LIST******************
    func getProductListManfacturing(page:String,commonFilter:String,completionHandler closure: @escaping([Productlist]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "storeId": Singleton.sharedInstance.retailerData.storeId!,
            "commonFilter" : commonFilter
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingProducts, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.manufacturingProductlist,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    //MARK: ******************GET PRODUCT DETAILS BY ID ******************
    func getManufacturingProductsDetail(product_id:String,completionHandler closure: @escaping(ManfacturingProductDetail?,String?,String?) -> Void) {
        let params = [
            "productId": product_id,
            "product_id": product_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getManufacturingProductsDetail, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.mafacturingProductDetail,data.msg!,data.status)
        }
    }
    //MARK: ******************Add PRODUCT TAX ******************
    func addProductSubSkill(product_id:String,subSkill:String,price:String,quantity:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "productId": product_id,
            "subSkill":subSkill,
            "price":price,
            "quantity":quantity,
            "storeId" :Singleton.sharedInstance.retailerData.storeId ?? "",
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addProductSubSkill, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************DELETE PRODUCT TAX ******************
    func deleteProductSubSkill(product_id:String,subSkillId:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "productId": product_id,
            "subSkillId":subSkillId,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPutRequest(url: EndPoint.deleteProductSubSkill, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************Add PRODUCT TAX ******************
    func getSubSkillonProduct(product_id:String,completionHandler closure: @escaping([SubSkillList]?,String?,String?) -> Void) {
        let params = [
            "productId": product_id,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getSubSkillonProduct, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.subSkillList,data.msg!,data.status)
        }
    }
    
    //MARK: ******************Add PRODUCT TAX ******************
    func addManufacturingDeal(title:String,userId:String,productId:String,subSkills:String,amount:String,quantity:String,description:String,deliveryDate:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "title": title,
            "productId": productId,
            "userId": userId,
            "storeId": Singleton.sharedInstance.retailerData.storeId!,
            "subSkills": subSkills,
            "amount": amount,
            "quantity": quantity,
            "description": description,
            "deliveryDate": deliveryDate,
            "adminId": Singleton.sharedInstance.retailerData.RetailerId!,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addManufacturingDeal, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************ADD USER API******************
    func addCustmerAPI(firstname:String,lastname:String,email:String,mobileNumber:String,countryCode:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "firstName":firstname,
            "lastName":lastname,
            "email":email,
            "mobileNumber":mobileNumber,
            "countryCode":countryCode
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.userNewRegistration, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    
    
}
