//
//  Result.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on April 12, 2022
//
import Foundation

struct Result: Codable {
    
    let retailerData: RetailerData?
    let id :String?
    let adminID : String?
    let admin_id : String?
    let mobileCode : [MobileCode]?
    let totalpage: Int?
    let totalPageCount: Int?
    let totalItemCount: Int?
    let totalCount : Int?
    let orderList: [OrderList]?
    let productlist: [Productlist]?
    let servicelist: [Servicelist]?
    let dropdowns: Dropdowns?
    let orderInfo: OrderInfo?
    
    let dashboardData: DashboardData?
    let storeList: [StoreList]?
    let storeInfo: StoreInfo?
    let settlementReport: SettlementReport?
    let userList: [UserList]?
    var userRole: [UserRole]?
    let loginDevices: [LoginDevices]?
    let orderStatusType: [OrderStatusType]?
    let commonFilter: [CommonFilter]?
    //ALLOCATION
    let trcList: [TRCList]?
    //SLOT
    let slotTime: SlotTime?
    let doctorData: [DoctorData]?
    let doctorTiming : [SlotEventsRepeat]?
    let salesReport : SalesReport?
    let filepath : String?
    let orderBatchInfo : OrderBatchInfo?
    let productDetails : ProductDetails?
    let userInfo : UserInfo?
    let cartInfo : CartInfo?
    let cartinfo : CartInfo?
    let order_Id : Int?
    // PRODUCT TAX
    let taxList: [ProductTaxList]?
    let productDetail : ProductDetail?
    
    
    
    
    
    //Inventory
    let inventorylist: [Inventorylist]?
    let statuslist: [StatusList]?
    let allAdminlist: [AllAdminList]?
//    SETTLEMENT
    let settlementData : SettlementData?
    
    let unitMeasurementList : [UnitMeasurementList]?
    
    // Deals
    let dealList : [DealList]?
    let salesOrderDetail : SalesOrderDetail?
    
    let workOrderList : [ManfacturingOrderListInfo]?
    
    let logsList : [LogsList]?
    let workFlow : [WorkFlow]?
    let manufacturingSubStatuslist: [ManufacturingSubStatuslist]?
    
    let manufacturingStatuslist: [ManufacturingStatuslist]?
    
    let dealWorkOrderList : [WorkOrderList]?
    let workOrderInfo : ManfacturingWorkOrderListInfo?
    
    let allSubSkillList : [SubSkillList]?
    let mafacturingProductDetail : ManfacturingProductDetail?
    
    
    let manufacturingProductlist: [Productlist]?
    
    let subSkillList : [SubSkillList]?
    
   
    
    private enum CodingKeys: String, CodingKey {
        case retailerData = "RetailerData"
        case id = "id"
        case adminID = "ADMIN_ID"
        case admin_id = "admin_id"
        case mobileCode = "MobileCode"
        case totalpage = "totalpage"
        case totalPageCount = "totalPageCount"
        case totalItemCount = "totalItemCount"
        case totalCount = "totalCount"
        case orderList = "orderList"
        case productlist = "productlist"
        case servicelist = "servicelist"
        case dropdowns = "dropdowns"
        case orderInfo = "orderInfo"
        case dashboardData = "dashboardData"
        case storeList = "storeList"
        case storeInfo = "storeInfo"
        case settlementReport = "settlementReport"
        case userList = "userList"
        case userRole = "userRole"
        case loginDevices = "loginDevices"
        
        case orderStatusType = "orderStatusType"
        case commonFilter = "commonFilter"
        //ALLOCATION
        case trcList = "TRCList"
        //SLOT
        case slotTime = "SlotTime"
        case doctorData = "DoctorData"
        case doctorTiming = "SlotEventsRepeat"
        case salesReport = "salesReport"
        case filepath = "filepath"
        case orderBatchInfo = "orderBatchInfo"
        case productDetails = "productDetails"
        case userInfo = "userInfo"
        case cartInfo = "cartInfo"
        case cartinfo = "cartinfo"
        case order_Id = "order_Id"
        // PRODUCT TAX
        case taxList = "taxList"
        // INVENTORY
        case inventorylist = "inventorylist"
        case statuslist = "statuslist"
        case allAdminlist = "allAdminlist"
        case productDetail = "productDetail"
        case settlementData = "settlementData"
       
        case unitMeasurementList = "UnitMeasurementList"
        
        case dealList = "dealList"
        
        case salesOrderDetail = "salesOrderDetail"
        
        case workOrderList = "workOrderList1"
        case logsList = "logsList"
        
        case workFlow = "workFlow"
        case manufacturingSubStatuslist = "manufacturingSubStatuslist"
        
        case dealWorkOrderList = "workOrderList"
        
        case workOrderInfo = "workOrderInfo"
        case manufacturingStatuslist = "manufacturingStatuslist"
        case allSubSkillList = "allSubSkillList"
        
        case mafacturingProductDetail = "manufacturingProductDetail"
        case manufacturingProductlist = "manufacturingProductlist"
        
        case subSkillList = "subSkillList"
        
        
        
     }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        retailerData = try values.decodeIfPresent(RetailerData.self, forKey: .retailerData)
        do {
            let idInt = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
            id = String(idInt )
        } catch DecodingError.typeMismatch {
            id = try values.decodeIfPresent(String.self, forKey: .id) ?? ""
        }
       
        do {
             let adminIDStr = try values.decodeIfPresent(Int.self, forKey: .adminID) ?? 0
            adminID = String(adminIDStr)
         } catch DecodingError.typeMismatch {
             adminID = try values.decodeIfPresent(String.self, forKey: .adminID) ?? "0"
         }
        
        mobileCode = try values.decodeIfPresent([MobileCode].self, forKey: .mobileCode)
        
        do {
             let totalpageInt = try values.decodeIfPresent(String.self, forKey: .totalpage) ?? "0"
            totalpage = Int(totalpageInt)
         } catch DecodingError.typeMismatch {
             totalpage = try values.decodeIfPresent(Int.self, forKey: .totalpage) ?? 0
         }
        
        do {
             let totalPageCountInt = try values.decodeIfPresent(String.self, forKey: .totalPageCount) ?? "0"
            totalPageCount = Int(totalPageCountInt)
         } catch DecodingError.typeMismatch {
             totalPageCount = try values.decodeIfPresent(Int.self, forKey: .totalPageCount) ?? 0
         }
        
        do {
             let totalItemCountInt = try values.decodeIfPresent(String.self, forKey: .totalItemCount) ?? "0"
            totalItemCount = Int(totalItemCountInt)
         } catch DecodingError.typeMismatch {
             totalItemCount = try values.decodeIfPresent(Int.self, forKey: .totalItemCount) ?? 0
         }
        do {
             let totalItemCountInt = try values.decodeIfPresent(String.self, forKey: .totalCount) ?? "0"
            totalCount = Int(totalItemCountInt)
         } catch DecodingError.typeMismatch {
             totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount) ?? 0//in Service List
         }
        orderList = try values.decodeIfPresent([OrderList].self, forKey: .orderList)
        productlist = try values.decodeIfPresent([Productlist].self, forKey: .productlist)
        servicelist = try values.decodeIfPresent([Servicelist].self, forKey: .servicelist)
        dropdowns = try values.decodeIfPresent(Dropdowns.self, forKey: .dropdowns)
        orderInfo = try values.decodeIfPresent(OrderInfo.self, forKey: .orderInfo)
        dashboardData = try values.decodeIfPresent(DashboardData.self, forKey: .dashboardData)
        storeList = try values.decodeIfPresent([StoreList].self, forKey: .storeList)
        storeInfo = try values.decodeIfPresent(StoreInfo.self, forKey: .storeInfo)
        do {
            settlementReport = try values.decodeIfPresent(SettlementReport.self, forKey: .settlementReport)
        } catch DecodingError.typeMismatch {
            settlementReport = nil
        }
        userList = try values.decodeIfPresent([UserList].self, forKey: .userList)
        userRole = try values.decodeIfPresent([UserRole].self, forKey: .userRole)
        loginDevices = try values.decodeIfPresent([LoginDevices].self, forKey: .loginDevices)
        
        orderStatusType = try values.decodeIfPresent([OrderStatusType].self, forKey: .orderStatusType)
        commonFilter = try values.decodeIfPresent([CommonFilter].self, forKey: .commonFilter)
        //ALLOCATION
        trcList = try values.decodeIfPresent([TRCList].self, forKey: .trcList)
        
        //SLOT
        slotTime = try values.decodeIfPresent(SlotTime.self, forKey: .slotTime)
        doctorData = try values.decodeIfPresent([DoctorData].self, forKey: .doctorData)
        doctorTiming = try values.decodeIfPresent([SlotEventsRepeat].self, forKey: .doctorTiming)
        salesReport = try values.decodeIfPresent(SalesReport.self, forKey: .salesReport)
        filepath = try values.decodeIfPresent(String.self, forKey: .filepath) ?? ""
        orderBatchInfo = try values.decodeIfPresent(OrderBatchInfo.self, forKey: .orderBatchInfo)
        productDetails = try values.decodeIfPresent(ProductDetails.self, forKey: .productDetails)
        userInfo = try values.decodeIfPresent(UserInfo.self, forKey: .userInfo)
        cartInfo = try values.decodeIfPresent(CartInfo.self, forKey: .cartInfo)
        cartinfo = try values.decodeIfPresent(CartInfo.self, forKey: .cartinfo)
        order_Id = try values.decodeIfPresent(Int.self, forKey: .order_Id)
        admin_id = try values.decodeIfPresent(String.self, forKey: .admin_id)
//      MARK: - TAX
        taxList = try values.decodeIfPresent([ProductTaxList].self, forKey: .taxList)
//      MARK: - INVENTORY
        inventorylist = try values.decodeIfPresent([Inventorylist].self, forKey: .inventorylist)
        statuslist = try values.decodeIfPresent([StatusList].self, forKey: .statuslist)
        allAdminlist = try values.decodeIfPresent([AllAdminList].self, forKey: .allAdminlist)
        productDetail = try values.decodeIfPresent(ProductDetail.self, forKey: .productDetail)
        
        settlementData = try values.decodeIfPresent(SettlementData.self, forKey: .settlementData)
        unitMeasurementList = try values.decodeIfPresent([UnitMeasurementList].self, forKey: .unitMeasurementList)
        
        dealList = try values.decodeIfPresent([DealList].self, forKey: .dealList)
        
        salesOrderDetail = try values.decodeIfPresent(SalesOrderDetail.self, forKey: .salesOrderDetail)
        
        workOrderList = try values.decodeIfPresent([ManfacturingOrderListInfo].self, forKey: .workOrderList)
        
        logsList = try values.decodeIfPresent([LogsList].self, forKey: .logsList)
        
        workFlow = try values.decodeIfPresent([WorkFlow].self, forKey: .workFlow)
        
        manufacturingSubStatuslist = try values.decodeIfPresent([ManufacturingSubStatuslist].self, forKey: .dealWorkOrderList)
        manufacturingStatuslist = try values.decodeIfPresent([ManufacturingStatuslist].self, forKey: .manufacturingStatuslist)
        
        dealWorkOrderList = try values.decodeIfPresent([WorkOrderList].self, forKey: .dealWorkOrderList)
        
        workOrderInfo = try values.decodeIfPresent(ManfacturingWorkOrderListInfo.self, forKey: .workOrderInfo)
        allSubSkillList = try values.decodeIfPresent([SubSkillList].self, forKey: .allSubSkillList)
        
        mafacturingProductDetail = try values.decodeIfPresent(ManfacturingProductDetail.self, forKey: .mafacturingProductDetail)
        manufacturingProductlist = try values.decodeIfPresent([Productlist].self, forKey: .manufacturingProductlist)
        
        subSkillList = try values.decodeIfPresent([SubSkillList].self, forKey: .subSkillList)
        
       
    }
}


struct Result2: Codable {
    
   
    let workFlow : [WorkFlow]?
    let customerList: [UserList]?
    private enum CodingKeys: String, CodingKey {
       
        case customerList = "customerList"
        case workFlow = "workFlow"
     }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        workFlow = try values.decodeIfPresent([WorkFlow].self, forKey: .workFlow)
        customerList = try values.decodeIfPresent([UserList].self, forKey: .customerList)
    }
}
