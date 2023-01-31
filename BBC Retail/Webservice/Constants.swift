//
//  Constants.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/04/22.
//

import Foundation

struct EndPoint{
    //VERSION
 fileprivate static let version = "/v9/"
   //BASE URL
    fileprivate static let baseURL = "https://retailmw.maaserp.com"//Live"
//   fileprivate static let baseURL = "https://bbcmw.newforceltd.com"// Staging
   
 //   fileprivate static let baseURL = "https://bbcmwstaging.newforceltd.com"// DayStaging
   
 //fileprivate static let baseURL = "https://bbcuatmw.newforceltd.com"  // UAT
 //fileprivate static let baseURL = "http://192.168.1.73/BBC_MW" // Test
    
   //QR CONTAINED URL
//    static let url =  "bbc.newforceltd.com"  // Staging
    static let url = "retail.maaserp.com"  //Live
    
   static let loginURL                      =   baseURL + version + "retailerSignIn"
   static let signUpURL                     =   baseURL + version + "retialer_sign_up"
   static let sendOTPURL                    =   baseURL + version + "sendRetailerMobile"
   static let reSendOTPURL                  =   baseURL + version + "resendOTP"
   static let checkRetailerOTPURL           =   baseURL + version + "checkRetailerOTP"
   static let countryCodesURL               =   baseURL + version + "mobileCode"
   static let addStoreProductsURL           =   baseURL + version + "addStoreProducts"
   static let insertRetailerLogs            =   baseURL + version + "insertRetailerLogs"
   static let getMainCategoryURL            =   baseURL + version + "getMainCategory"
   static let getStoreOrderListURL          =   baseURL + version + "getStoreOrderList"
   static let getRetailerProductstURL       =   baseURL + version + "getRetailerProducts"
   static let getCustomerOrderDetailByIdURL =   baseURL + version + "getCustomerOrderDetailById"
   static let getCustomerOrderByBatchId     =   baseURL + version + "getCustomerOrderByBatchId"
   static let checkRetailerExist            =   baseURL + version + "checkRetailerExist"
   static let checkRetailerOtpExist         =   baseURL + version + "checkRetailerOtpExist"
   static let updateRetailerPassword        =   baseURL + version + "updateRetailerPassword"
   static let updateStoreProduct            =   baseURL + version + "updateStoreProduct"
   static let getStoreList                  =   baseURL + version + "getStoreList"
   static let getStoreInfo                  =   baseURL + version + "getStoreInfo"
   static let addStoreServices              =   baseURL + version + "addStoreServices"
   static let addHospitalServices           =   baseURL + version + "addHospitalServices" 
   static let getRetailerServices           =   baseURL + version + "getRetailerServices"
   static let getRetailerMember             =   baseURL + version + "getRetailerMember"
   static let updateRetailerMember          =   baseURL + version + "updateRetailerMember"
   static let addRetailerMember             =   baseURL + version + "addRetailerMember"
   static let retailerLogout                =   baseURL + version + "retailerLogout"
   static let retailerSettlementReport      =   baseURL + version + "retailerSettlementReport"
   static let retailerDashboardReport       =   baseURL + version + "retailerDashboardReport"
   static let getListAllLogged              =   baseURL + version + "getListAllLogged"
   static let logoutAllLogged               =   baseURL + version + "logoutAllLogged"
   static let retailerSalesReport           =   baseURL + version + "retailerSalesReport"
   static let getAllProductsAndBarCode      =   baseURL + version + "getAllProductsAndBarCode"
   static let orderStatusType               =   baseURL + version + "orderStatusType"
   static let OrderLogURL                   =   baseURL + version + "OrderLog"
   static let getCommonFilterURL            =   baseURL + version + "getCommonFilter"
 
   //ALLOCATION
   static let listTRCDataURL                =   baseURL + version + "listTRCData"
   static let addTRCDataURL                 =   baseURL + version + "addTRCData"
   static let searchProductURL              =   baseURL + version + "searchProduct"
    static let searchProductReck            =   baseURL + version + "searchProduct"
    static let searchWaiterURL              =   baseURL + version + "getRetailerMember"
   static let updateTRCStoreURL             =   baseURL + version + "updateTRCStore"
   static let assignTRCDataURL              =   baseURL + version + "assignTRCData"
    static let addTableAPI                  =   baseURL + version + "addTRCData"
    static let editTableAPI                 =   baseURL + version + "updateTRCStore"
    
    static let assignTable                  =   baseURL + version + "assignTRCData"
    
   //APPOINTMENT RESCADULE
    static let rescheduleBookSlotURL        =   baseURL + version + "rescheduleBookSlot"
    static let getRescheduleDataByDocIdURL  =   baseURL + version + "getRescheduleDataByDocId"
    static let updateSlotStatusURL          =   baseURL + version + "updateSlotStatus"
    static let deleteAccount                =   baseURL + version + "retailerDeleteAccount"
    
    //DOCTOR AVAILABILITY
    static let DoctorDetail                 =   baseURL + version + "getDoctorDetailByStoreId"
    static let doctorSlot                   =   baseURL + version + "getDoctorCommonData"
    static let createSlot                   =   baseURL + version + "createSlot"
    static let doctorAvability              =   baseURL + version + "getCustomerBookedSlotByDocId"
    static let allSalesExportData           =   baseURL + version + "allSalesExportData"
    static let orderStatusChange            =   baseURL + version + "orderStatusChange"
    static let getUserDetails               =   baseURL + version + "getUserDetails"
    static let updateUserDetails            =   baseURL + version + "updateUserDetails"
    static let updateCartQty                =   baseURL + version + "updateCartQty"
    static let deleteCartitem               =   baseURL + version + "deleteCartitem"
    static let getProductDetailsBySku       =   baseURL + version + "getProductDetailsBySku"
    static let addToCart                    =   baseURL + version + "addToCart"
    static let getCartDetailsByRetailer     =   baseURL + version + "getCartDetailsByRetailer"
    static let generateOrderByRetailer      =   baseURL + version + "generateOrderByRetailer"
    static let OrderSuccessByRetailer       =   baseURL + version + "OrderSuccessByRetailer"
    
    //CAB DRIVER
    static let addCabServices               =   baseURL + version + "addCabServices"
    static let getCabAllocationData         =   baseURL + version + "getCabAllocationData"
    static let addAndAssignTaxiData         =   baseURL + version + "addAndAssignTaxiData"
    static let updateCabLocationData        =   baseURL + version + "updateCabLocationData"
    static let assignCabData                =   baseURL + version + "assignCabData"
    
    // TAX ON PRODUCT
    static let getTaxList                   =   baseURL + version + "getTaxList"
    static let getProductDetailById         =   baseURL + version + "getProductDetailById"
    static let addProductTax                =   baseURL + version + "addProductTax"
    static let deleteProductTax             =   baseURL + version + "deleteProductTax"
    
    //  MANGE INVENTORTY
     static let fetchProductLogsNew          =  baseURL + version + "fetchProductLogsNew"
     static let getMovementType              =  baseURL + version + "getMovementType"
     static let getInventoryStatus           =  baseURL + version + "getInventoryStatus"
     static let getAdminStoreNew             =  baseURL + version + "getAdminStoreNew"
     static let insertRetailerProductlogsNew =  baseURL + version + "insertRetailerProductlogsNew"
     static let addStockTransportlogsNew     =  baseURL + version + "addStockTransportlogsNew"
     static let getStoreProduct              =  baseURL + version + "getStoreProduct"
   
    static let getStripeKeyApi              =   baseURL + version + "fetchApiKeys"
    static let fetchStripePayments                =   baseURL + version + "fetchStripePayments"
    static let makeTransfers                =   baseURL + version + "makeTransfers"
   
    static let getConversionListDropdwon           =   baseURL + version + "ConversionListDropdwon"
    
    // Sales order
    static let getDealsList                 = baseURL + version + "ManufacturingDealList"
    static let manufacturingDealDetail                 = baseURL + version + "ManufacturingDealDetail_IOSCOPY"
    static let getStoreDetailedInfo                 = baseURL + version + "getStoreDetailedInfo"
    
    static let getRetailerLogs                 = baseURL + version + "getRetailerLogs"
  
    
    static let fetchManufacturingWorkflowData                 = baseURL + version + "fetchManufacturingWorkflowData"
    
    
    static let addDealLogsAndWorkflow                 = baseURL + version + "addDealLogsAndWorkflow"
    
    static let getManufacturingStatus                 = baseURL + version + "getManufacturingStatus"
    
    static let getManufacturingOrderList                 = baseURL + version + "getManufacturingOrderList"
    static let getManufacturingOrderDetailById                 = baseURL + version + "getManufacturingOrderDetailById"
    
    static let addOrderLogsAndWorkflow                 = baseURL + version + "addOrderLogsAndWorkflow"
 
    static let addProductSubSkill                 = baseURL + version + "addProductSubSkill"
    static let getAllSubSkill                 = baseURL + version + "getAllSubSkill_IOSCOPY"
    
    static let getManufacturingProductsDetail                 = baseURL + version + "getManufacturingProductsDetail_IOSCOPY"
    static let addManufacturingProduct                 = baseURL + version + "addManufacturingProduct"
    static let updateManufacturingProduct                 = baseURL + version + "updateManufacturingProduct"
    
    static let getManufacturingProducts                 = baseURL + version + "getManufacturingProducts_IOSCOPY"
 
   
    static let deleteProductSubSkill             =   baseURL + version + "deleteProductSubSkill"
    static let getSubSkillonProduct             =   baseURL + version + "getSubSkillonProduct"
    
    static let addManufacturingDeal             =   baseURL + version + "addManufacturingDeal"
    
    static let getCustomersList             =   baseURL + version + "getCustomersList"
    
    static let userRegistration             =   baseURL + version + "userRegistration"
    static let userNewRegistration             =   baseURL + version + "userNewRegistration"
    
    static let addProductWithoutInventory             =   baseURL + version + "addProductWithoutInventory"
    
    static let productUpdate             =   baseURL + version + "productUpdate"
    
    
    
   }
//**************SELECT DROPDOWN*************************
enum DataType{
    case serviceGroup
    case searchMember
    case searchProduct_Service
    case countryCode
    case mainCategory
    case subCategory
    case fkGrandChildCategoryId
    case userRole
    case userStatus
    case doctors
    case orderStatus
    case event
    case calendar
    case statuslist
    case movementList
    case alladminList
    case unitConversionList
    case none

    }

enum DropdownType{
    case defaultType
    case apiSuggesionSearch
    case apiGetSearch
   }

//**************ACTION POPUP*************************
enum DropdownAction{
    case YesNo
    case Okay
    case none
   }

enum DropdownActionType{
    case logout
    case storeExit
    case multiplePackage
    case changeStore
    case openCart
    case storeInactive
    case none
    case deleteAccount
    }
//***************************
