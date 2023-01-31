//
//  APIManger.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/04/22.
//

import UIKit
import Alamofire
import FirebaseMessaging
import FTIndicator
import Ipify

class WebServiceManager {
    
    // static let header : HTTPHeaders = ["outhKey":"$^%$^*(^&%","fcm_token":Messaging.messaging().fcmToken! ,"retailer_id":Singleton.sharedInstance.retailerData.RetailerId ?? ""]
    static let sharedInstance = WebServiceManager()
    let userDefault = UserDefaults.standard
    let keyChainAccess = KeychainAccess()
    
    //MARK: ******************Stripe Transaction ******************
    
    func settlePayment(store_id:String = Singleton.sharedInstance.retailerData.storeId ?? "",currency:String,amount:Int,account_id:String,OrderID:String,completionHandler closure: @escaping(SettlementData?,String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "currency":currency,
            "amount":amount,
            "account_id":account_id,
            "order_ids":OrderID,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.makeTransfers, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.settlementData,data.msg!,data.status)
        }
    }
    
    func checkStripeTransactionListing(store_id:String = Singleton.sharedInstance.retailerData.storeId ?? "",completionHandler closure: @escaping(SettlementData?,String?,String?) -> Void) {
        let params = [
            "storeId":store_id,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.fetchStripePayments, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.settlementData,data.msg!,data.status)
        }
    }
    
    
    func getPublicIP(closure:@escaping(String) -> Void)  {
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
            return
        }
        Ipify.getPublicIPAddress { result in
            switch result {
            case .success(let ip):
                print(ip) // "210.11.178.112"
                closure(ip)
            case .failure(let error):
                print(error.localizedDescription)
                closure("103.149.154.7")
            }
        }
    }
    func getIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else {return nil}
        guard let firstAddr = ifaddr else {return nil}
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        return address
    }
    //MARK: ******************LOGIN******************
    func loginAPI(userName:String,password:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let messaging = Messaging.messaging()
        let token = messaging.fcmToken
        //   let ipAddress = getIPAddress()
        let udid = keyChainAccess.checkUniqueID()
        getPublicIP { ip in
            let params = [
                "username": userName,
                "password":password,
                "device_token": udid ,
                "ip_address":ip,
                "fcm_token":token ?? "",
                "add_from":"ios",
                "device": UIDevice.modelName
                // "location": location,
            ] as [String : Any]
            WebServiceManager.sharedInstance.AFPostRequestLogin(url: EndPoint.loginURL, parameters: params) { data,error  in
                guard let data = data else{
                    
                    return}
                if data.status == "1"{
                    Singleton.sharedInstance.retailerData = data.result?.retailerData
                    
                    if   Singleton.sharedInstance.retailerData.settings?.lowercased() == "enable"{ //Check if store setting enble/disable
                        Singleton.sharedInstance.retailerData.userRole = data.result?.userRole
                      
                        print("Payment method========>>>>>>>",Singleton.sharedInstance.retailerData.paymentMethod)
                        let nameArray = Singleton.sharedInstance.retailerData.StoreName?.components(separatedBy: " ")
                        let currency = nameArray?.last ?? ""
                        let currencySymbol = self.getSymbolForCurrencyCode(code: currency)
                        UserDefaults.standard.setValue(currency, forKey: "currency")
                        //    print(UserDefaults.standard.string(forKey: "currency") as Any)
                        
                        UserDefaults.standard.setValue(currencySymbol, forKey: "currencySymbol")
                        //       print(UserDefaults.standard.string(forKey: "currencySymbol")!)
                        self.userDefault.save(customObject: Singleton.sharedInstance.retailerData,inKey:"retailerData")
                        if let savedPerson = self.userDefault.object(forKey: "retailerData") as? Data {
                            let decoder = JSONDecoder()
                            if let loadedPerson = try? decoder.decode(RetailerData.self, from: savedPerson){
                                print(loadedPerson.RetailerId!)
                            }
                        }
                    }else{
                        Singleton.sharedInstance.retailerData = nil
                        closure("Please enable store setting first!","0")
                        return
                    }
                }
                closure(data.msg,data.status)
            }
        }
    }
    func getSymbolForCurrencyCode(code: String) -> String?{
        let locale = NSLocale(localeIdentifier: code)
        return locale.displayName(forKey: NSLocale.Key.currencySymbol, value: code)
    }
    //MARK: ******************Check User Exist Send OTP******************
    func checkUserExist(username:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "username":username
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestLogin(url:  EndPoint.checkRetailerExist, parameters:params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
//        AFPostRequest(url:, parameters: params)
    }
    //MARK: ******************Check User Exist Send OTP******************
    func checkRetailerOtpExist(username:String,otp:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "username":username,
            "otp" :otp
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestOuthKey(url: EndPoint.checkRetailerOtpExist, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************Check User Exist Send OTP******************
    func resetRetailerPassword(username:String,pass:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "username":username,
            "password" :pass
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestOuthKey(url: EndPoint.updateRetailerPassword, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************DASHBOARD REPORT ALL DATA******************
    func retailerDashboardReport(completionHandler closure: @escaping(DashboardData?,String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.retailerDashboardReport, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.dashboardData!,data.msg!,data.status)
        }
    }
    //MARK: ******************DASHBOARD SETTLEMENT REPORT DATA******************
    func settelmentDashboardReport(completionHandler closure: @escaping(SettlementReport?,String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.retailerSettlementReport, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.settlementReport,data.msg!,data.status)
        }
    }
    //MARK: ******************LOGIN******************
    func signUpAPI(storename:String,storeimage:UIImage?,firstname:String,lastname:String,email:String,address:String,zipcode:String,gstnumber:String,mobilenumber:String,countryCode:String,cityname:String,pannumber:String,admin_type:String,password:String,admin_id:String,service_group:String,qrCode:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "storename":storename,
            "country_code": countryCode,
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "address":address,
            "zipcode":zipcode,
            "gstnumber":gstnumber,
            "mobilenumber":mobilenumber,
            "cityname":cityname,
            "pannumber":pannumber,
            "admin_type":admin_type,
            "password":password,
            "admin_id":admin_id,
            "service_group":service_group,
            "storeimage":storeimage as Any,
            "qrCode":qrCode
            
        ] as [String : Any]
        WebServiceManager.sharedInstance.alamofireImageUPLOAD(url: EndPoint.signUpURL, image: storeimage, fileParameter:  "storeimage", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ******************SEND OTP******************
    func sendOTPAPI(countryCode:String,mobile:String,completionHandler closure: @escaping(String?,String?,String?) -> Void) {
        let params = [
            "country_code": countryCode,
            "mobile_number":mobile
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestOuthKey(url: EndPoint.sendOTPURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.adminID,data.msg,data.status)
        }
    }
    //MARK: ******************RESEND OTP******************
    func reSendOTPAPI(adminID:String,mobile_number:String,country_code:String,completionHandler closure: @escaping(String?,String?,String?) -> Void) {
        let params = [
            "admin_id": adminID,
            "mobileNumber": mobile_number,
            "countryCode" : country_code,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestOuthKey(url: EndPoint.reSendOTPURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            
            closure(data.result?.adminID,data.msg,data.status)
        }
    }
    //MARK: ******************VERIFY OTP******************
    func verifyOTPAPI(otp:String,adminID:String,countryCode:String,mobileNumber:String,completionHandler closure: @escaping(String?,String?,String?) -> Void) {
        let params = [
            "admin_id": adminID,
            "OTP": otp,
            "countryCode" :countryCode,
            "mobileNumber":mobileNumber
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequestOuthKey(url: EndPoint.checkRetailerOTPURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.adminID,data.msg,data.status)
        }
    }
    //MARK: ******************GET COUNTRY CODE******************
    func getCountryCodeAPI(completionHandler closure: @escaping([DropDownModel]?,String?,String?) -> Void) {
        WebServiceManager.sharedInstance.AFGetRequestOuthKey(url: EndPoint.countryCodesURL){ data,error  in
            guard let data:Base = data else{
                return}
            
            closure(data.result?.mobileCode,data.msg,data.status)
        }
    }
    //MARK: ******************GET ORDER STATUS******************
    func getOrderStatus(completionHandler closure: @escaping([OrderStatusType]?,String?,String?) -> Void) {
        let params = [
            "retailer_id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "store_type":Singleton.sharedInstance.retailerData.storeType ?? "",
            "vertical":Singleton.sharedInstance.retailerData.category ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.orderStatusType, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.orderStatusType
            
            closure(dropdowns,data.msg,data.status)
        }
    }
    //MARK: ******************UPDATE ORDER STATUS API******************
    func updateOrderStatus(paymentMethod:String,userID:String,status:String,oderID:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId!,
            "order_id":oderID,
            "status":status,
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId!,
            "user_id":userID,
            "comments": "",
            "store_name":Singleton.sharedInstance.retailerData.StoreName ?? "",
            "payment_method":paymentMethod,
            "vertical":Singleton.sharedInstance.retailerData.category ?? ""
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.OrderLogURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ****************** ADD  PRODUCT ******************
    func addProduct(productImage:UIImage,costPrice:String,productPrice:String,offerPrice:String,name:String,shortDescr:String,currencyType:String,productQuanty:String,mainID:String,childID:String,grandChildID:String,barcodeId:String,TAXTYPE:String,TAXID:String,UNIT:String,PACKAGE_FLAG:String,PACKAGE_PRICE:String,PACKAGE_QTY:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        var params = [
            "Retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "STORE_ID" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "PRODUCT_NAME":name,
            "PRORDUCT_SHORT_DESCRIPTION":shortDescr,
            "Product_Quantity":productQuanty,
            "Product_Offer_Price":offerPrice,
            "Product_Price":productPrice,
            "Currency_Type":currencyType,
            "FK_MAIN_CATEGORY_ID":mainID,
            "FK_CHILD_CATEGORY_ID":childID,
            "FK_GRAND_CHILD_CATEGORY_ID":grandChildID,
            "Cost_Price":costPrice,
            "COURSE_AVTAR":productImage,
            "barcode_id":barcodeId,
            "TAXTYPE":TAXTYPE,
            "TAXID":TAXID,
            "TAXON":"product",
            "UNIT":UNIT,
            "PACKAGE_FLAG":PACKAGE_FLAG,
            "PACKAGE_PRICE":PACKAGE_PRICE,
            "PACKAGE_QTY":PACKAGE_QTY,
 
        ] as [String : Any]
      
         var url =  EndPoint.addProductWithoutInventory
        if Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
            url =  EndPoint.addStoreProductsURL
        }
       
        
        
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url: url, image: productImage, fileParameter:  "COURSE_AVTAR", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }

    
    //MARK: ****************** DELETE USER ******************
    func deleteUserAPI(completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "retailerId":Singleton.sharedInstance.retailerData.RetailerId!,
            "currentStatus":"delete",
            "accessKeyPID": Singleton.sharedInstance.retailerData.accessKeyPID!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.deleteAccount, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ****************** EDIT  PRODUCT ******************
    func editProduct(productImage:UIImage,costPrice:String,productPrice:String,offerPrice:String,name:String,shortDescr:String,currencyType:String,productQuanty:String,mainID:String,childID:String,productID:String,TAXID:String,UNIT:String,PACKAGE_FLAG:String,PACKAGE_PRICE:String,PACKAGE_QTY:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            
            "PRODUCT_NAME" :name,
            "PRORDUCT_SHORT_DESCRIPTION":shortDescr,
            "Store_id" :Singleton.sharedInstance.retailerData.storeId ?? "",
            "Retailer_id": Singleton.sharedInstance.retailerData.RetailerId!,
            "Product_Quantity":productQuanty,
            "product_id":productID,
            "Product_Offer_Price":offerPrice,
            "Product_Price":productPrice,
            "Cost_Price":costPrice,
            "FK_MAIN_CATEGORY_ID":mainID,
            "FK_CHILD_CATEGORY_ID":childID,
            "COURSE_AVTAR" :productImage,
            "TAXON":"product",
            "TAXID":TAXID,
            "UNIT":UNIT,
            "PACKAGE_FLAG":PACKAGE_FLAG,
            "PACKAGE_PRICE":PACKAGE_PRICE,
            "PACKAGE_QTY":PACKAGE_QTY,
        ] as [String : Any]
       
        var url =  EndPoint.productUpdate
       if Singleton.sharedInstance.retailerData.inventory  == "with inventory"{
           url =  EndPoint.updateStoreProduct
       }
      
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url: url, image: productImage, fileParameter:  "COURSE_AVTAR", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ****************** ADD SERVICE HOSPITAL/RESOURENT ******************
    func addService(productImage:UIImage,halfPrice:String,fullPrice:String,name:String,shortDescr:String,currencyType:String,mainID:String,childID:String,grandChildID:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params : [String:Any]?
        let url : String?
        if Singleton.sharedInstance.retailerData.category?.lowercased() == "hospital"{
            url = EndPoint.addHospitalServices
            params = [
                "STORE_ID" : Singleton.sharedInstance.retailerData.storeId ?? "",
                "RETAILER_ID":Singleton.sharedInstance.retailerData.RetailerId!,
                "SERVICE_NAME":name,
                "SERVICE_SHORT_DESCRIPTION":shortDescr,
                "Currency_Type":currencyType,
                "FULLPRICE":fullPrice,
                "COURSE_AVTAR":productImage
            ] as [String : Any]
        }else{
            url = EndPoint.addStoreServices
            params = [
                "HALFPRICE":halfPrice,
                "SERVICE_SHORT_DESCRIPTION":shortDescr,
                "Currency_Type":currencyType,
                "FK_MAIN_CATEGORY_ID":mainID,
                "FK_CHILD_CATEGORY_ID":childID,
                "FK_GRAND_CHILD_CATEGORY_ID":grandChildID,
                "STORE_ID":Singleton.sharedInstance.retailerData.storeId ?? "",
                "FULLPRICE":fullPrice,
                "RETAILER_ID":Singleton.sharedInstance.retailerData.RetailerId!,
                "SERVICE_NAME":name,
                "COURSE_AVTAR":productImage
            ] as [String : Any]
        }
        
        
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url:url!, image: productImage, fileParameter:  "COURSE_AVTAR", parameter: params! as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    
    //MARK: ******************GET PRODUCT LIST******************
    func getProductList(page:String,commonFilter:String,completionHandler closure: @escaping([Productlist]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "store_id": Singleton.sharedInstance.retailerData.storeId!,
            "commonFilter" : commonFilter
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRetailerProductstURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productlist,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    //MARK: ****************** GET COMMON FILTER  ******************
    func getCommonFilterAPI(type:String,mainCat:String,vertical:String = "",sub_type:String = "",completionHandler closure: @escaping([CommonFilter]?,String?,String?) -> Void) {
        let params = [
            "filter_type":type, //ProductList OrderList
            "store_id" :Singleton.sharedInstance.retailerData.storeId!,
            "mainCategory" : mainCat,
            "vertical" : vertical,
            "sub_type": sub_type,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCommonFilterURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.commonFilter,data.msg!,data.status)
        }
    }
    
    //MARK: ****************** CHANGE PRODUCT STATUS ******************
    func changeProductStatusApi(status:String,RefId:String,adminId:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "STATUS":status, //ProductList OrderList
            "REF_ID" :RefId,
            "STATUS_COMMENT" : "Changed from iOS app",
            "REF_TYPE":"MASTER_COURSES",
            "CREATE_BY":adminId
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.insertRetailerLogs, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************GET SERVICE  LIST******************
    func getServiceList(page:String,completionHandler closure: @escaping([Servicelist]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "store_id": Singleton.sharedInstance.retailerData.storeId ?? ""
            
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRetailerServices, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.servicelist,data.result?.totalpage,data.result?.totalCount,data.msg!,data.status)
        }
    }
    //MARK: ******************GET STORES LIST******************
    func getStoresList(page:String,completionHandler closure: @escaping([StoreList]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "retialer_id": Singleton.sharedInstance.retailerData.RetailerId!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreList, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.storeList,data.result?.totalpage,data.result?.totalPageCount,data.msg!,data.status)
        }
    }
    //MARK: ******************GET STORE INFO******************
    func getStoreInfo(store_id:String,completionHandler closure: @escaping(StoreInfo?,String?,String?) -> Void) {
        let params = [
            "store_id": store_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreInfo, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.storeInfo,data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET PRODUCT DETAILS BY ID ******************
    func getProductDetailsById(product_id:String,completionHandler closure: @escaping(ProductDetail?,String?,String?) -> Void) {
        let params = [
            "product_id": product_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getProductDetailById, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productDetail,data.msg!,data.status)
        }
    }
    
    //MARK: ******************Add PRODUCT TAX ******************
    func addProductTax(product_id:String,tax_id:String,tax_type:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "product_id": product_id,
            "tax_id":tax_id,
            "tax_type":tax_type
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addProductTax, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************DELETE PRODUCT TAX ******************
    func deleteProductTax(product_id:String,tax_id:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "product_id": product_id,
            "tax_id":tax_id,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.deleteProductTax, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************GET LOGIN ACTIVITY******************
    func getLoginActivity(completionHandler closure: @escaping([LoginDevices]?,String?,String?) -> Void) {
        let params = [
            "retailer_id": Singleton.sharedInstance.retailerData.RetailerId!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getListAllLogged, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.loginDevices,data.msg!,data.status)
        }
    }
    //MARK: ****************** LOGOUT ALL DEVICES ******************
    func logoutAllDevicesApi(completionHandler closure: @escaping(String?,String?) -> Void) {
        let messaging = Messaging.messaging()
        let token = messaging.fcmToken
        let params = [
            "retailer_id": Singleton.sharedInstance.retailerData.RetailerId!,
            "fcm_token" : token ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.logoutAllLogged, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET USERS LIST******************
    func getUsersList(page:String,keyword:String?,completionHandler closure: @escaping([UserList]?,Int?,Int?,String?,String?) -> Void) {
        var params = [
            "storeId":Singleton.sharedInstance.retailerData.storeId!,
            "page":page,
            "retailerId": Singleton.sharedInstance.retailerData.RetailerId!,
            "vertical": Singleton.sharedInstance.retailerData.category!
            
        ] as [String : Any]
        if keyword != nil{
            params.merge(with: ["keyword": keyword!])
        }
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRetailerMember, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.userList,data.result?.totalpage,data.result?.totalPageCount,data.msg!,data.status)
        }
        
        
        
        
        
    }
    
    //MARK: ******************GET USERS LIST******************
    func getCustomersList(page:String,keyword:String?,completionHandler closure: @escaping([UserList]?,Int?,Int?,String?,String?) -> Void) {
        var params = [:
            
        ] as [String : Any]
        if keyword != nil{
            params.merge(with: ["keyword": keyword!])
        }
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCustomersList, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result2?.customerList,data.result?.totalpage,data.result?.totalPageCount,data.msg!,data.status)
        }
        
    }
  
  
    //MARK: ******************ADD USER API******************
    func addUserAPI(firstname:String,lastname:String,email:String,mobileNumber:String,userType:String,password:String,countryCode:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "storeId":Singleton.sharedInstance.retailerData.storeId!,
            "retailerId":Singleton.sharedInstance.retailerData.RetailerId!,
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "mobileNumber":mobileNumber,
            "userType":userType,
            "password":password,
            "storeName":Singleton.sharedInstance.retailerData.StoreName!,
            "countryCode":countryCode
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addRetailerMember, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************UPDATE USER API******************
    func updateUserAPI(firstname:String,lastname:String,email:String,mobileNumber:String,userType:String,memberId:String,countryCode:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            
            "storeId":Singleton.sharedInstance.retailerData.storeId!,
            "retailerId":Singleton.sharedInstance.retailerData.RetailerId!,
            "firstname":firstname,
            "lastname":lastname,
            "email":email,
            "countryCode":countryCode,
            "mobileNumber":mobileNumber,
            "userType":userType,
            "memberId":memberId,
            "status":status
            
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.updateRetailerMember, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************GET SALES ORDER LIST******************
    func getSalesOrderList(page:String,commonFilter:String,completionHandler closure: @escaping([OrderList]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "commonFilter":commonFilter,
            "page":page,
            "store_id":Singleton.sharedInstance.retailerData.storeId!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreOrderListURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.orderList,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    //MARK: ****************** GET ORDER DETAILS ******************
    func getCustomerOrderByBatchId(orderID:String,vertical:String,order_batch_id:String,payment_method:String,product_type:String,completionHandler closure: @escaping(OrderBatchInfo?,String?,String?) -> Void) {
        let params = [
            "order_id":orderID,
            "vertical" :vertical,
            "order_batch_id" : order_batch_id,
            "payment_method" : payment_method,
            "product_type" : product_type
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCustomerOrderByBatchId, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.orderBatchInfo,data.msg!,data.status)
        }
    }
    
    //MARK: ****************** GET ORDER DETAILS ******************
    func getOrderDetails(orderID:String,vertical:String,product_type:String,completionHandler closure: @escaping(OrderInfo?,String?,String?) -> Void) {
        let params = [
            "order_id":orderID,
            "vertical" :vertical,
            "product_type" : product_type
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCustomerOrderDetailByIdURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.orderInfo,data.msg!,data.status)
        }
    }
    //MARK: ******************LOGOUT API******************
    func logoutAPI(completionHandler closure: @escaping(String?,String?) -> Void) {
        let messaging = Messaging.messaging()
        let token = messaging.fcmToken
        let params = [
            "fcm_token":token!,
            "Retailer_id": Singleton.sharedInstance.retailerData.RetailerId!
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.retailerLogout, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************GET TRC ALLOCATION LIST******************
    func getTRCAllocationList(page:String,completionHandler closure: @escaping([TRCList]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "storeId": Singleton.sharedInstance.retailerData.storeId!
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.listTRCDataURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.trcList,data.result?.totalpage,data.result?.totalCount,data.msg!,data.status)
        }
    }
    //MARK: ******************GET CAB ALLOCATION LIST******************
    func getCabAllocationList(page:String,completionHandler closure: @escaping([TRCList]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "page":page,
            "storeId": Singleton.sharedInstance.retailerData.storeId!
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCabAllocationData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.trcList,data.result?.totalpage,data.result?.totalCount,data.msg!,data.status)
        }
    }
    //MARK: ****************** ADD  ROOM TRC ******************
    func addRoomTRC(number:String,allocation_type:String,allocation_ID:String,location:String,floor:String,productID:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "create_by":Singleton.sharedInstance.retailerData.ADMINID!,
            "number":number,
            "setting_type":Singleton.sharedInstance.retailerData.storeType!,
            "allocation_type":allocation_type,
            "product_id":productID,
            "location":location,
            "vertical":Singleton.sharedInstance.retailerData.category!,
            "title":"Room",
            "floor":floor,
            "allocation_id" : allocation_ID,
            
            // "assignCategory":113
            // "assignSubcategory":274
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addTRCDataURL, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ****************** ADD RECK API ******************
    func AddReckAPI(store_id:String,create_by:String,number:String,setting_type:String,allocation_type:String,product_id:String,location:String,vertical:String,title:String,floor:String,assignSubcategory:String,assignCategory:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "create_by":create_by,
            "number": number,
            "setting_type": setting_type,
            "allocation_type" : allocation_type,
            "product_id":product_id,
            "location":location,
            "vertical":vertical,
            "title":title,
            "floor":floor,
            "assignSubcategory": assignSubcategory,
            "assignCategory":assignCategory
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addTableAPI, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    //MARK: ****************** ASSIGN RECK API ******************
    func AssignReckAPI(store_id:String,trcstore_Id:String,product_id:String,allocation_type:String,assignSubcategory:String,assignCategory:String,create_by:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "trcstore_Id":trcstore_Id,
            "product_id": product_id,
            "allocation_type":allocation_type,
            "create_by":create_by,
            "assignSubcategory":assignSubcategory,
            "assignCategory":assignCategory
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.assignTable, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    
    
    //MARK: ****************** ADD TABLE API ******************
    func AddTableAPI(store_id:String,create_by:String,number:String,setting_type:String,allocation_type:String,allocation_id:String,location:String,vertical:String,title:String,floor:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "create_by":create_by,
            "number": number,
            "setting_type": setting_type,
            "allocation_type" : allocation_type,
            "allocation_id":allocation_id,
            "location":location,
            "vertical":vertical,
            "title":title,
            "floor":floor
            // "assignCategory":113
            // "assignSubcategory":274
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addTableAPI, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ****************** EDIT TABLE API ******************
    func EditTableAPI(storeId:String,trcstore_Id:String,number:String,location:String,status:String,floor:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "storeId":storeId,
            "trcstore_Id":trcstore_Id,
            "number": number,
            "location":location,
            "status":status,
            "floor":floor
            // "assignCategory":113
            // "assignSubcategory":274
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.editTableAPI, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    
    //MARK: ****************** ASSIGN TABLE API ******************
    func AssignTableAPI(store_id:String,trcstore_Id:String,allocation_id:String,allocation_type:String,create_by:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "trcstore_Id":trcstore_Id,
            "allocation_id": allocation_id,
            "allocation_type":allocation_type,
            "create_by":create_by
        ] as [String : Any]
        
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.assignTable, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    
    
    //MARK: ****************** EDIT  ROOM TRC ******************
    func editRoomTRC(number:String,trcstore_Id:String,location:String,floor:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            
            "trcstore_Id":trcstore_Id,
            "storeId":Singleton.sharedInstance.retailerData.storeId ?? "",
            "location":location,
            "floor":floor,
            "number":number,
            "status":status
            // "assignCategory":113
            // "assignSubcategory":274
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.updateTRCStoreURL, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ****************** ASSIGN  ROOM TRC ALLOCATION ******************
    func assignRoomTRC(trcstore_Id:String,allocation_type:String,allocation_ID:String,productID:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "create_by":Singleton.sharedInstance.retailerData.ADMINID!,
            "allocation_type":allocation_type,
            "product_id":productID,
            "trcstore_Id":trcstore_Id,
            "allocation_id" : allocation_ID
            //  "assignSubcategory":280
            //  "assignCategory":117
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.assignTRCDataURL, parameters: params) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
    //MARK: ******************SEARCH PRODUCT LIST******************
    func searchProductList(page:String,keyword:String,completionHandler closure: @escaping([Productlist]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId!,
            "page":page,
            "keyword":keyword
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.searchProductURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productlist,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    //MARK: ******************SEARCH PRODUCT LIST******************
    func searchProductListAPI(store_id:String,page:String,keyword:String,vertical:String,completionHandler closure: @escaping([Productlist]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "store_id":store_id,
            "page":page,
            "keyword":keyword,
            "vertical":vertical
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.searchProductReck, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productlist,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    //MARK: ******************SEARCH WAITER LIST******************
    func searchWaiterList(page:String,keyword:String,retailerId:String,completionHandler closure: @escaping([UserList]?,Int?,Int?,String?,String?) -> Void) {
        let params = [
            "storeId":Singleton.sharedInstance.retailerData.storeId!,
            "page":page,
            "keyword":keyword,
            "vertical": "restaurant",
            "retailerId" : retailerId
            //  "RETAILER_ID":Singleton.sharedInstance.retailerData.store_id!
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.searchWaiterURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.userList,data.result?.totalpage,data.result?.totalItemCount,data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************RESCHEDULE SLOT******************
    func resceduleSlot(slot_id:String,service_id:String,user_id:String,slot_date:String,slot_start_time:String,slot_end_time:String,order_id:String,status:String,doctor_name:String,payment_method:String,previous_date:String,room_id:String,doctor_id:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "slot_id":slot_id,
            "service_id":service_id,
            "user_id":user_id,
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId!,
            "slot_date":slot_date,
            "slot_start_time":slot_start_time,
            "slot_end_time":slot_end_time,
            "vertical":Singleton.sharedInstance.retailerData.category ?? "",
            "store_id":Singleton.sharedInstance.retailerData.storeId!,
            "order_id":order_id,
            "status":status,
            "doctor_name":doctor_name,
            "payment_method":payment_method,
            "previous_date":previous_date,
            "room_id":room_id,
            "doctor_id":doctor_id
            
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.rescheduleBookSlotURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************RESCHEDULE DATA OF SLOT******************
    func getResceduleDataSlot(doctor_Id:String,date:String,service_Id:String,day:String,completionHandler closure: @escaping(SlotTime?,String?,String?) -> Void) {
        let params = [
            "store_Id":Singleton.sharedInstance.retailerData.storeId!,
            "doctor_Id":doctor_Id,
            "date":date,
            "vertical":Singleton.sharedInstance.retailerData.category ?? "",
            "service_Id":service_Id,
            "day":day
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getRescheduleDataByDocIdURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.slotTime,data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************UPDATE SLOT STATUS******************
    func updateSlotStatus(store_id:String,room_id:String,status:String,slot_id:String,service_id:String,user_id:String,order_id:String,doctor_name:String,previous_date:String,payment_method:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "room_id":room_id,
            "slot_id":slot_id,
            "service_id":service_id,
            "user_id":user_id,
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId!,
            "status":status,
            "vertical":Singleton.sharedInstance.retailerData.category ?? "",
            "store_id":store_id,
            "order_id":order_id,
            "doctor_name":doctor_name,
            "previous_date":previous_date,
            "payment_method":payment_method
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.updateSlotStatusURL, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************UPDATE TAXI STATUS******************
    func updateCabLocationData(storeId:String,number:String,trcstore_Id:String,floor:String,location:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "storeId":storeId,
            "number":number,
            "trcstore_Id":trcstore_Id,
            "floor":floor,
            "location":location,
            "status":status
           
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.updateCabLocationData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    //MARK: ******************ASSIGN TAXI STATUS******************
    func AssignCabLocationData(create_by:String,store_id:String,allocation_type:String,service_id:String,trcstore_Id:String,allocation_id:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "create_by":create_by,
            "store_id":store_id,
            "allocation_type":allocation_type,
            "service_id":service_id,
            "trcstore_Id":trcstore_Id,
            "allocation_id":allocation_id
           
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.assignCabData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }

    //MARK: ******************* **************** ****************  *************************************************************************************************
    func downloadFile(url: String, completionHandler:@escaping(URL?,Double,String, Bool)->()){
        let downloadUrl: String = url
        let destination: DownloadRequest.Destination = { _, _ in
            let url = URL(string: downloadUrl)
            _ = url?.pathExtension // pdf
            let fileName = url?.lastPathComponent
            let directoryURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let folderPath: URL = directoryURL.appendingPathComponent("NFDownloads", isDirectory: true)
            let fileURL: URL = folderPath.appendingPathComponent(fileName!)
            // let urlEx = fileURL.appendingPathExtension(fileExtension!)
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        // print(downloadUrl)
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.download(downloadUrl, to: destination)
            .downloadProgress { progress in
                print(progress.fractionCompleted)
                completionHandler(nil, progress.fractionCompleted,"",false)
                // print("\(Int(progress.fileCompletedCount!))")
            }
            .responseData { response in
                print("response: \(response)")
                switch response.result{
                case .success( _):
                    let fileURL = response.fileURL
                    //  print(fileURL?.absoluteString)
                    // print(response.result)
                    completionHandler(fileURL, 1,"Success",true)
                    break
                case .failure(let error):
                    print(error)
                    completionHandler(nil, 0, "Error",false)
                    break
                }
            }
    }
    
    //MARK: ******************PRODUCT TAX LIST API******************
    func getProductTax(completionHandler closure: @escaping([ProductTaxList]?,String?,String?) -> Void) {
        let params = [
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId ?? "",
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getTaxList, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.taxList,data.msg!,data.status)
        }
    }
    
    //MARK: ******************GET INVENTAORY API LIST******************
    func getProductInventtoryList(course_id:String,completionHandler closure: @escaping([Inventorylist]?,String?,String?) -> Void) {
        let params = [
            "course_id":course_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.fetchProductLogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            
            closure(data.result?.inventorylist,data.msg,data.status)
        }
    }
    
    //MARK: ******************GET INVENTAORY STATUS API LIST******************
    func getInventtoryStatusList(completionHandler closure: @escaping([StatusList]?,String?,String?) -> Void) {
        WebServiceManager.sharedInstance.AFGetRequest(url: EndPoint.getInventoryStatus){ data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.statuslist
            
            closure(dropdowns,data.msg,data.status)
        }
    }
    //MARK: ******************GET ALL ADMIN STORE LIST******************
    func getAllAdminStoreList(completionHandler closure: @escaping([AllAdminList]?,String?,String?) -> Void) {
        let nameArray = Singleton.sharedInstance.retailerData.StoreName?.components(separatedBy: " ")
        let currency = nameArray?.last ?? ""
        let params = [
            "admin_id":Singleton.sharedInstance.retailerData.ADMINID ?? "",
            "admin_type":Singleton.sharedInstance.retailerData.ADMINTYPE ?? "",
            "currency":currency,
            "page":"1",
            "type":"product"
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getAdminStoreNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.allAdminlist
            closure(dropdowns,data.msg,data.status)
        }
    }
    
    //MARK: ******************GET MOVEMENT TYPE API LIST******************
    func getMovementStatusList(completionHandler closure: @escaping([StatusList]?,String?,String?) -> Void) {
        WebServiceManager.sharedInstance.AFGetRequest(url: EndPoint.getMovementType){ data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.statuslist
            
            closure(dropdowns,data.msg,data.status)
        }
    }
    
    //MARK: ******************INSERT RETAILOR PRODUCT FOR GOOD RECEIPT LOGS API ******************
    func insertRetailerProductlogsNewApi(course_id:String,prodcut_quantity:String,standard_price:String,sender_store_id:String,status_comment:String,status:String,offer_price:String,cost_price:String,create_by:String,conversion_id:String,unit_id : String,product_unit : String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "course_id":course_id,
            "prodcut_quantity":prodcut_quantity,
            "standard_price":standard_price,
            "sender_store_id":sender_store_id,
            "status_comment":status_comment,
            "status":status,
            "offer_price":offer_price,
            "cost_price":cost_price,
            "create_by":create_by,
            "conversion_id" : conversion_id,
            "unit_id" : unit_id,
            "product_unit" : product_unit,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.insertRetailerProductlogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
 
    //MARK: ******************INSERT RETAILOR PRODUCT FOR PHYSICAL INVENTORY LOGS API ******************
    func physicalInventorylogsNewApi(course_id:String,admin_id:String,admin_type:String,prodcut_quantity:String,currency:String,page:String,type:String,standard_price:String,sender_store_id:String,status_comment:String,status:String,offer_price:String,cost_price:String,create_by:String,conversion_id:String,unit_id : String,product_unit : String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "admin_id":admin_id,
            "admin_type":admin_type,
            "course_id":course_id,
            "currency":currency,
            "page":page,
            "type":type,
            "prodcut_quantity":prodcut_quantity,
            "standard_price":standard_price,
            "sender_store_id":sender_store_id,
            "status_comment":status_comment,
            "status":status,
            "offer_price":offer_price,
            "cost_price":cost_price,
            "create_by":create_by,
            "conversion_id" : conversion_id,
            "unit_id" : unit_id,
            "product_unit" : product_unit,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.insertRetailerProductlogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************INSERT RETAILOR PRODUCT FOR EDIT PRICE LOGS API ******************
    func editPricelogsNewApi(course_id:String,prodcut_quantity:String,standard_price:String,sender_store_id:String,status_comment:String,status:String,offer_price:String,cost_price:String,create_by:String,conversion_id:String,unit_id : String,product_unit:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "course_id":course_id,
            "prodcut_quantity":prodcut_quantity,
            "standard_price":standard_price,
            "sender_store_id":sender_store_id,
            "status_comment":status_comment,
            "status":status,
            "offer_price":offer_price,
            "cost_price":cost_price,
            "create_by":create_by,
            "conversion_id" : conversion_id,
            "unit_id" : unit_id,
            "product_unit" : product_unit,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.insertRetailerProductlogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************INSERT RETAILOR PRODUCT FOR STOCK TRANSPORT LOGS API ******************
    func addStockTransportlogsNewAp(course_id:String,standard_price:String,status_comment:String, new_product_add:String,offer_price:String,receiver_store_id:String,create_by:String,prodcut_quantity:String,sender_store_id:String,price:String,receiver_product_id:String,cost_price:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "course_id":course_id,
            "new_product_add":new_product_add,
            "receiver_store_id":receiver_store_id,
            "price":price,
            "prodcut_quantity":prodcut_quantity,
            "standard_price":standard_price,
            "sender_store_id":sender_store_id,
            "status_comment":status_comment,
            "status":status,
            "offer_price":offer_price,
            "cost_price":cost_price,
            "create_by":create_by,
            "receiver_product_id":receiver_product_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addStockTransportlogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
 
   
    //MARK: ******************GET STOCK TRANSPORT GET STORE PRODUCT LIST******************
    func getStoreProductList(sub_cat:String,main_cat:String,product_name:String,Store_id:String,completionHandler closure: @escaping([Productlist]?,String?,String?) -> Void) {
            let nameArray = Singleton.sharedInstance.retailerData.StoreName?.components(separatedBy: " ")
            let currency = nameArray?.last ?? ""
            let params = [
                "sub_cat":sub_cat,
                "Store_id":Store_id,
                "main_cat":main_cat,
                "product_name":product_name,
                "type":"product"
            ] as [String : Any]
            WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getStoreProduct, parameters: params) { data,error  in
                guard let data:Base = data else{
                    return}
            
                closure(data.result?.productlist,data.msg,data.status)
            }
    }
    
    
    //MARK: ******************INSERT RETAILOR PRODUCT FOR GOOD ISSUE LOGS API ******************
    func goodIssuelogsNewApi(course_id:String,prodcut_quantity:String,standard_price:String,sender_store_id:String,status_comment:String,status:String,offer_price:String,cost_price:String,create_by:String,movement_type:String,conversion_id:String,unit_id : String,product_unit : String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "course_id":course_id,
            "prodcut_quantity":prodcut_quantity,
            "standard_price":standard_price,
            "sender_store_id":sender_store_id,
            "status_comment":status_comment,
            "status":status,
            "offer_price":offer_price,
            "cost_price":cost_price,
            "create_by":create_by,
            "movement_type":movement_type,
            "conversion_id" : conversion_id,
            "unit_id" : unit_id,
            "product_unit" : product_unit,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.insertRetailerProductlogsNew, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }


    //MARK: ****************ALAMOFIRE GET REQUEST********************
    func AFGetRequest(url:String,completionHandler closure:@escaping(Base?,String) -> Void) {  //Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            //  print("Internet is'Nt available.")
            //   self.alertPopup(title: "Oops!", message:"Please Check Internet Connectivity.", image: Gif)
            // ...
        }
        print(url,getHeaders())
        //
        //                AF.request(url,method: .post,parameters:parameters as? Parameters,encoding: URLEncoding.httpBody,headers:headers).responseString { response in
        //
        //                 print(response.result)
        //                }
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .get,headers:getHeaders()).responseString{ response in//
            print(response.result)
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Base.self, from: data)
                if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                    self.authFailed(msg: data.msg ?? "")
                    return
                }
                closure(data,"")
            } catch let error {
                SKActivityIndicator.dismiss()
                FTIndicator.showToastMessage("Server Error! Please try again later.")
                //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                print(error)
                let errorCode = response.response?.statusCode
                print(errorCode!)
                closure(nil,"")
            }
        }
    }
    //MARK: ****************ALAMOFIRE GET REQUEST WITH OUTH KEY********************
    func AFGetRequestOuthKey(url:String,completionHandler closure:@escaping(Base?,String) -> Void) {  //Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            //  print("Internet is'Nt available.")
            //   self.alertPopup(title: "Oops!", message:"Please Check Internet Connectivity.", image: Gif)
            // ...
        }
        print(url,getHeadersLogin())
        //
        //                AF.request(url,method: .post,parameters:parameters as? Parameters,encoding: URLEncoding.httpBody,headers:headers).responseString { response in
        //
        //                 print(response.result)
        //                }
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .get,headers:getHeadersLogin()).responseString{ response in//
            print(response.result)
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Base.self, from: data)
                if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                    self.authFailed(msg: data.msg ?? "")
                    return
                }
                closure(data,"")
            } catch let error {
                SKActivityIndicator.dismiss()
                FTIndicator.showToastMessage("Server Error! Please try again later.")
                //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                print(error)
                let errorCode = response.response?.statusCode
                print(errorCode!)
                closure(nil,"")
            }
        }
    }
    
    //MARK: ****************ALAMOFIRE PUT REQUEST********************
    func AFPutRequest(url:String,parameters:Parameters,completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeaders())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .put,parameters:parameters,encoding: URLEncoding.httpBody,headers:getHeaders()).responseString{ response in//
            print(response.result)
            switch (response.result) {
            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Server Error! Please try again later.")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
            case .failure(let error):
                SKActivityIndicator.dismiss()
                if error._code == NSURLErrorTimedOut {
                    FTIndicator.showToastMessage("Request timeout!")
                    print("ERRROR:  Request timeout!")
                }
                if error._code == NSURLErrorNetworkConnectionLost {
                    print("ERRROR:  Connection Lost!")
                    FTIndicator.showToastMessage("Connection Lost!")
                }
                if error._code == NSURLErrorNotConnectedToInternet {
                    print("ERRROR:  Internet not avialable")
                    FTIndicator.showToastMessage("Internet not avialable")
                }
                if error._code == NSURLErrorCannotConnectToHost {
                    print("ERRROR:  Could not connect to the server")
                    FTIndicator.showToastMessage("Could not connect to the server")
                }
            }
        }
    }
    //MARK: ****************ALAMOFIRE POST REQUEST********************
    func AFPostRequest12(url:String,parameters:Parameters,completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeaders())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .post,parameters:parameters,encoding: URLEncoding.httpBody,headers:getHeaders()).responseString{ response in//
            print(response)
//            switch (response) {
//            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Server Error! Please try again later.")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
//            case .failure(let error):
//                SKActivityIndicator.dismiss()
//                if error._code == NSURLErrorTimedOut {
//                    FTIndicator.showToastMessage("Request timeout!")
//                    print("ERRROR:  Request timeout!")
//                }
//                if error._code == NSURLErrorNetworkConnectionLost {
//                    print("ERRROR:  Connection Lost!")
//                    FTIndicator.showToastMessage("Connection Lost!")
//                }
//                if error._code == NSURLErrorNotConnectedToInternet {
//                    print("ERRROR:  Internet not avialable")
//                    FTIndicator.showToastMessage("Internet not avialable")
//                }
//                if error._code == NSURLErrorCannotConnectToHost {
//                    print("ERRROR:  Could not connect to the server")
//                    FTIndicator.showToastMessage("Could not connect to the server")
//                }
//            }
        }
    }
    
    //MARK: ****************ALAMOFIRE POST REQUEST********************
    func AFPostRequest(url:String,parameters:Parameters,encoding:URLEncoding  = URLEncoding.httpBody,headers:HTTPHeaders = getHeaders(),completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeaders())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .post,parameters:parameters,encoding: encoding,headers:headers).responseString{ response in//
            print(response.result)
            switch (response.result) {
            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Server Error! Please try again later.")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
            case .failure(let error):
                SKActivityIndicator.dismiss()
                if error._code == NSURLErrorTimedOut {
                    FTIndicator.showToastMessage("Request timeout!")
                    print("ERRROR:  Request timeout!")
                }
                if error._code == NSURLErrorNetworkConnectionLost {
                    print("ERRROR:  Connection Lost!")
                    FTIndicator.showToastMessage("Connection Lost!")
                }
                if error._code == NSURLErrorNotConnectedToInternet {
                    print("ERRROR:  Internet not avialable")
                    FTIndicator.showToastMessage("Internet not avialable")
                }
                if error._code == NSURLErrorCannotConnectToHost {
                    print("ERRROR:  Could not connect to the server")
                    FTIndicator.showToastMessage("Could not connect to the server")
                }
            }
        }
    }
    
    //MARK: ****************ALAMOFIRE POST REQUEST WITH OUTHKEY****************
    //****PAK**********
    func AFPostRequestOuthKey(url:String,parameters:Parameters,completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeadersOuthKey())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .post,parameters:parameters,encoding: URLEncoding.httpBody,headers:getHeadersOuthKey()).responseString{ response in//
            print(response.result)
            switch (response.result) {
            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Server Error! Please try again later.")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
            case .failure(let error):
                SKActivityIndicator.dismiss()
                if error._code == NSURLErrorTimedOut {
                    FTIndicator.showToastMessage("Request timeout!")
                    print("ERRROR:  Request timeout!")
                }
                if error._code == NSURLErrorNetworkConnectionLost {
                    print("ERRROR:  Connection Lost!")
                    FTIndicator.showToastMessage("Connection Lost!")
                }
                if error._code == NSURLErrorNotConnectedToInternet {
                    print("ERRROR:  Internet not avialable")
                    FTIndicator.showToastMessage("Internet not avialable")
                }
                if error._code == NSURLErrorCannotConnectToHost {
                    print("ERRROR:  Could not connect to the server")
                    FTIndicator.showToastMessage("Could not connect to the server")
                }
            }
        }
    }
    func AFPostRequestLogin(url:String,parameters:Parameters,completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeadersOuthKey())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .post,parameters:parameters,encoding: URLEncoding.httpBody,headers:getHeadersLogin()).responseString{ response in//
            print(response.result)
            switch (response.result) {
            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Please enter valid credentials")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
            case .failure(let error):
                SKActivityIndicator.dismiss()
                if error._code == NSURLErrorTimedOut {
                    FTIndicator.showToastMessage("Request timeout!")
                    print("ERRROR:  Request timeout!")
                }
                if error._code == NSURLErrorNetworkConnectionLost {
                    print("ERRROR:  Connection Lost!")
                    FTIndicator.showToastMessage("Connection Lost!")
                }
                if error._code == NSURLErrorNotConnectedToInternet {
                    print("ERRROR:  Internet not avialable")
                    FTIndicator.showToastMessage("Internet not avialable")
                }
                if error._code == NSURLErrorCannotConnectToHost {
                    print("ERRROR:  Could not connect to the server")
                    FTIndicator.showToastMessage("Could not connect to the server")
                }
            }
        }
    }
    //MARK: ****************ALAMOFIRE PUT REQUEST********************
    func AFPPutRequest(url:String,parameters:Parameters,completionHandler closure: @escaping(Base?,String) -> Void) {//Session Expired
        if !NetworkState.isConnected(){
            SKActivityIndicator.dismiss()
            FTIndicator.showToastMessage("Please Check Internet Connectivity.")
        }
        print(url,parameters,getHeaders())
        
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        manager.request(url,method: .put,parameters:parameters,encoding: URLEncoding.httpBody,headers:getHeaders()).responseString{ response in//
            print(response.result)
            switch (response.result) {
            case .success: // succes path
                guard let data = response.data else { return }
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(Base.self, from: data)
                    if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                        self.authFailed(msg: data.msg ?? "")
                        return
                    }
                    closure(data,"")
                } catch let error {
                    SKActivityIndicator.dismiss()
                    //    self.alertPopup(title: "Oops!", message: "Server Error! Please try again later.", image: self.Gif)
                    FTIndicator.showToastMessage("Server Error! Please try again later.")
                    print(error)
                    let errorCode = response.response?.statusCode
                    print(errorCode!)
                    closure(nil,"0")
                }
            case .failure(let error):
                SKActivityIndicator.dismiss()
                if error._code == NSURLErrorTimedOut {
                    FTIndicator.showToastMessage("Request timeout!")
                    print("ERRROR:  Request timeout!")
                }
                if error._code == NSURLErrorNetworkConnectionLost {
                    print("ERRROR:  Connection Lost!")
                    FTIndicator.showToastMessage("Connection Lost!")
                }
                if error._code == NSURLErrorNotConnectedToInternet {
                    print("ERRROR:  Internet not avialable")
                    FTIndicator.showToastMessage("Internet not avialable")
                }
                if error._code == NSURLErrorCannotConnectToHost {
                    print("ERRROR:  Could not connect to the server")
                    FTIndicator.showToastMessage("Could not connect to the server")
                }
            }
        }
    }
    
    
    //MARK: -Almofire Image Upload Multipart request
    func alamofireImageUPLOAD(url:String,image:UIImage?,fileParameter:String,parameter : NSDictionary, completionHandler: @escaping (Base?,Int) -> ()) {
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        let api = manager.upload(multipartFormData: { (multipartFormData) in
            print(url,parameter,getHeaders())
            for (key, value) in parameter
            {
                if key as! String == fileParameter {
                    guard let img =  image else{
                        //  multipartFormData.append(("" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        return}
                    if let imageData = img.jpegData(compressionQuality: 0.6) {
                        multipartFormData.append(imageData, withName: fileParameter, fileName: "file.jpg", mimeType: "image/jpg")
                    }
                }else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
            }
        }, to:url,method: .post,headers: getHeadersOuthKey())
        api.uploadProgress { (Progress) in
            print("Upload Progress: \(Progress.fractionCompleted)")
        }
        api.responseString
        {
            response -> Void in
            print(response.result)
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Base.self, from: data)
                if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                    self.authFailed(msg: data.msg ?? "")
                    return
                }
                completionHandler(data,response.response?.statusCode ?? 00)
            } catch let error {
                SKActivityIndicator.dismiss()
                FTIndicator.showToastMessage("Server Error! Please try again later")
                print(error)
                let errorCode = response.response?.statusCode
                print(errorCode!)
            }
        }
    }
    
    func alamofireImageUPLOADAfterSignIn(url:String,image:UIImage?,fileParameter:String,parameter : NSDictionary, completionHandler: @escaping (Base?,Int) -> ()) {
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        let api = manager.upload(multipartFormData: { (multipartFormData) in
            print(url,parameter,getHeaders())
            for (key, value) in parameter
            {
                if key as! String == fileParameter {
                    guard let img =  image else{
                        //  multipartFormData.append(("" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                        return}
                    if let imageData = img.jpegData(compressionQuality: 0.6) {
                        multipartFormData.append(imageData, withName: fileParameter, fileName: "file.jpg", mimeType: "image/jpg")
                    }
                }else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
            }
        }, to:url,method: .post,headers: getHeaders())
        api.uploadProgress { (Progress) in
            print("Upload Progress: \(Progress.fractionCompleted)")
        }
        api.response
        {
            response -> Void in
            // print(response.result)
            guard let data = response.data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(Base.self, from: data)
                if data.msg!.contains("Authorization Failed") || data.msg!.contains("Access key not found"){
                    self.authFailed(msg: data.msg ?? "")
                    return
                }
                completionHandler(data,response.response?.statusCode ?? 00)
            } catch let error {
                SKActivityIndicator.dismiss()
                FTIndicator.showToastMessage("Server Error! Please try again later")
                print(error)
                let errorCode = response.response?.statusCode
                print(errorCode!)
            }
        }
    }
    //MARK: -Almofire Doc Upload Multipart  request
    func    alamofireUPLOAD(url:String,fileURL:URL,header:HTTPHeaders,fileParameter:String,parameter : NSDictionary , urlString : String, completionHandler: @escaping (Data?,Int) -> ()) {
        let manager = AF
        manager.session.configuration.timeoutIntervalForRequest = 20
        let api = manager.upload(multipartFormData:{ (multipartFormData) in
            
            for (key, value) in parameter
            {
                if key as! String == fileParameter {
                    //                    let pdfData = try! Data(contentsOf: fileURL)
                    //                    var data : Data = pdfData
                    multipartFormData.append(fileURL, withName: fileParameter) // "application/pdf"
                }else{
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
                }
            }
        }, to: url,method: .post,headers: getHeaders())
        api.uploadProgress { (Progress) in
            print("Upload Progress: \(Progress.fractionCompleted)")
        }
        api.responseString
        {
            response -> Void in
            print(response.result)
            completionHandler(response.data!,response.response?.statusCode ?? 00)
        }
    }
    func authFailed(msg:String){
        if msg.contains("Access key not found"){
            let dropDown =  DropdownActionPopUp.init(title: "Please login again.",header:"Session Expired!",action: .Okay, type: .logout, sender: (UIApplication.shared.keyWindow?.rootViewController)!, image: nil,tapDismiss:false)
            
            dropDown.alertActionVC.delegate = self
        }else{
            let dropDown =  DropdownActionPopUp.init(title: "Please try again.",header:msg,action: .Okay, type: .none, sender: (UIApplication.shared.keyWindow?.rootViewController)!, image: nil,tapDismiss:false)
            
            dropDown.alertActionVC.delegate = self
        }
    }
    //MARK: ******************GET MAIN CATEGORY******************
    func getMainCategoryAPI(completionHandler closure: @escaping(Dropdowns?,String?,String?) -> Void) {
        WebServiceManager.sharedInstance.AFGetRequest(url: EndPoint.getMainCategoryURL){ data,error  in
            guard let data:Base = data else{
                return}
            let dropdowns = data.result?.dropdowns
            closure(dropdowns,data.msg,data.status)
        }
    }
    
    //MARK: ******************ConversionListDropdwon******************
    func getConversionListDropdwonAPI(parameters:Parameters,completionHandler closure: @escaping([UnitMeasurementList]?,String?,String?) -> Void) {
       
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getConversionListDropdwon, parameters: parameters,encoding: URLEncoding.httpBody) { data,error  in
            guard let data:Base = data else{
                return}
            let dropDowns = data.result?.unitMeasurementList
            closure(dropDowns,data.msg!,data.status)
        }
    }
    
    //MARK: ******************DOCTORS DETAIL POST API******************
    func getDoctorDetailByStoreId(completionHandler closure: @escaping([DoctorData]?,String?,String?) -> Void) {
        let params = [
            "store_Id":Singleton.sharedInstance.retailerData.storeId!,
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "vertical":Singleton.sharedInstance.retailerData.category ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.DoctorDetail, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropDowns = data.result?.doctorData
            closure(dropDowns,data.msg!,data.status)
        }
    }
    
    //MARK: ******************DOCTORS SLOTS POST API******************
    func getDoctorAvability(doctor_id:String,date:String,day:String,completionHandler closure: @escaping(SlotTime?,String?,String?) -> Void) {
        let params = [
            "store_Id":Singleton.sharedInstance.retailerData.storeId!,
            "doctor_id":doctor_id,
            "vertical":Singleton.sharedInstance.retailerData.category ?? "",
            "date":date,
            "day":day
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.doctorAvability, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            let dropDowns = data.result?.slotTime
            closure(dropDowns,data.msg!,data.status)
        }
    }
    //MARK: ******************ADD CAB POST API******************
    func addCabServiceAPI(productImage:UIImage,SERVICE_NAME:String,PRICE:String,allocation_type:String,setting_type:String,to_address:String,title:String,from_latitude:String,create_by:String,number:String,to_longitude:String,from_longitude:String,SERVICE_SHORT_DESCRIPTION:String,CURRENCY_TYPE:String,allocation_id:String,STORE_ID:String,to_latitude:String,location:String,floor:String,RETAILER_ID:String,from_address:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "SERVICE_NAME": SERVICE_NAME,
            "PRICE":PRICE,
            "setting_type":setting_type,
            "title":title,
            "create_by": create_by,
            "SERVICE_SHORT_DESCRIPTION":SERVICE_SHORT_DESCRIPTION,
            "CURRENCY_TYPE":CURRENCY_TYPE,
            "STORE_ID":STORE_ID,
            "RETAILER_ID":RETAILER_ID,
            "COURSE_AVTAR":productImage
        ] as [String : Any]
        WebServiceManager.sharedInstance.alamofireImageUPLOADAfterSignIn(url:EndPoint.addCabServices, image: productImage, fileParameter:  "COURSE_AVTAR", parameter: params as NSDictionary) { data,error  in
            guard let data = data else{
                return}
            closure(data.msg,data.status)
        }
    }
  
    
    
    //MARK: ******************GET DOCTOR COMMON DATA SLOT******************
    func getDoctorCommonDataSlot(completionHandler closure: @escaping([SlotEventsRepeat]?,String?,String?) -> Void) {
        WebServiceManager.sharedInstance.AFGetRequest(url: EndPoint.doctorSlot){ data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.doctorTiming,data.msg,data.status)
        }
    }
    
    //MARK: ******************Check User Exist Send OTP******************
    func createSlot(doctor_Id:String,doctor_Name:String,event_Type:String,days:String,start_Time:String,End_Time:String,from_date:String,recurring:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_Id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "doctor_Id":doctor_Id,
            "store_Type":Singleton.sharedInstance.retailerData.storeType ?? "",
            "event_Type":event_Type,
            "days":days,
            "start_Time":start_Time,
            "End_Time":End_Time,
            "from_date":from_date,
            "recurring":recurring,
            "status":status,
            "doctor_Name":doctor_Name,
            "vertical": Singleton.sharedInstance.retailerData.category ?? "",
            "retailer_id": Singleton.sharedInstance.retailerData.RetailerId ?? ""
            
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.createSlot, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    //MARK: ******************DASHBOARD SALE OR APPOINTMENT REPORT DATA******************
    func retailerSalesReport(completionHandler closure: @escaping(SalesReport?,String?,String?) -> Void) {
        let params = [
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "retailer_id": Singleton.sharedInstance.retailerData.RetailerId ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.retailerSalesReport, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.salesReport,data.msg!,data.status)
        }
    }
    
    //MARK: ******************All Sales Export Data ******************
    func allSalesExportData(startDate:String,exportType:String,endDate:String,month:String,day_type:String,completionHandler closure: @escaping(String,String?,String?) -> Void) {
        let params = [
            "day_type" : day_type,
            "month" : month,
            "endDate" : endDate,
            "exportType" : exportType,
            "startDate" : startDate,
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.allSalesExportData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.filepath ?? "",data.msg!,data.status)
        }
    }
    
    //MARK: ******************CHANGE ORDER STATUS API******************
    func changeOrderStatusAPI(store_id:String,slot_start_time:String,slot_date:String,sub_status:String,service_name:String,retailer_id:String,vertical:String,user_id:String,service_id:String,doctor_name:String,order_id:String,payment_method:String,status:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            
            "store_id":Singleton.sharedInstance.retailerData.storeId ?? "",
            "slot_start_time":slot_start_time,
            "slot_date":slot_date,
            "sub_status":sub_status,
            "service_name":service_name,
            "retailer_id":Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "vertical":vertical,
            "user_id":user_id,
            "service_id":service_id,
            "doctor_name":doctor_name,
            "order_id":order_id,
            "payment_method":payment_method,
            "status":status
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.orderStatusChange, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status)
        }
    }
    
    
    //MARK: ******************GET USER DETAIL ******************
    func getUserDetails(countryCode:String,mobileNumber:String,completionHandler closure: @escaping(UserInfo?,String?,String?) -> Void) {
        let params = [
            "countryCode" : countryCode,
            "mobileNumber" : mobileNumber,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getUserDetails, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.userInfo ,data.msg!,data.status)
        }
    }
    
    //MARK: ******************UPDATE USER DETAIL ******************
    func updateUserDetails(firstName:String,lastName:String,email:String,countryCode:String,mobileNumber:String,userId:String,completionHandler closure: @escaping(String,String?,String?) -> Void) {
        let params = [
            "firstName" : firstName,
            "lastName" : lastName,
            "email" : email,
            "countryCode" : countryCode,
            "mobileNumber" : mobileNumber,
            "userId" : userId
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPutRequest(url: EndPoint.updateUserDetails, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.filepath ?? "",data.msg!,data.status ?? "")
        }
    }
    
    //MARK: ******************UPDATE CART QUANTITY ******************
    func updateCartQty(cart_id:String,productQuantity:String,user_id:String,qty:String,cart_main_id:String,completionHandler closure: @escaping(String,String?,String?) -> Void) {
        let params = [
            "cart_id" : cart_id,
            "productQuantity" : productQuantity,
            "qty" : qty,
            "cart_main_id" : cart_main_id,
            "user_id" : user_id,
            "retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.updateCartQty, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.filepath ?? "",data.msg!,data.status ?? "")
        }
//        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.updateCartQty, parameters: params) { data,error  in
//            guard let data:Base = data else{
//                return}
//            closure(data.result?.filepath ?? "",data.msg!,data.status ?? "")
//        }
    }
    
    //MARK: ******************UPDATE CART QUANTITY ******************
    func deleteCartitem(cart_id:String,user_id:String,cart_main_id:String,completionHandler closure: @escaping(String,String?,String?) -> Void) {
        let params = [
            "cart_id" : cart_id,
            "retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "cart_main_id" : cart_main_id,
            "user_id" : user_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPPutRequest(url: EndPoint.deleteCartitem, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.filepath ?? "",data.msg!,data.status ?? "")
        }
    }
    
    //MARK: ******************GET PRODUCT DETAILS ******************
    func getProductDetailsBySku(sku:String,completionHandler closure: @escaping(ProductDetails?,String?,String?) -> Void) {
        let params = [
            "sku" : sku,
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getProductDetailsBySku, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.productDetails ,data.msg!,data.status ?? "")
        }
    }
    
    //MARK: ******************ADD TO CART ******************
    func addToCart(productQuantity:String,product_offer_price:String,user_id:String,product_id:String,qty:String,store_type:String,inventory:String,payment_method:String,completionHandler closure: @escaping(CartInfo?,String?,String?) -> Void) {
        let params = [
            "store_id" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "productQuantity" : productQuantity,
            "product_offer_price" : product_offer_price,
            "user_id" : user_id,
            "product_id" : product_id,
            "qty" : qty,
            "retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "vertical" : Singleton.sharedInstance.retailerData.category ?? "",
            "store_type" : store_type,
            "inventory" : inventory,
            "payment_method" : payment_method,
           
        ] as [String : Any]
    
        
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addToCart, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.cartInfo  ,data.msg!,data.status ?? "")
        }
    }
    
    
    //MARK: ******************GET CART DETAILS BY RETAILER******************
    
    func getCartDetailsByRetailer(user_id:String,completionHandler closure: @escaping(CartInfo?,[Productlist]?,String?,String?) -> Void) {
        let params = [
            "store_id" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "user_id" : user_id
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.getCartDetailsByRetailer, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.cartinfo,data.result?.productlist  ,data.msg!,data.status ?? "")
        }
    }
    
    //MARK: ******************GENERATE ORDER BY RETAILER******************
    
    func generateOrderByRetailer(user_id:String,store_name:String,cart_main_id:String,store_type:String,completionHandler closure: @escaping(Int?,String?,String?) -> Void) {
        let params = [
            "store_id" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "user_id" : user_id,
            "retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "store_name" : store_name,
            "vertical" : "FMCG",
            "cart_main_id" : cart_main_id,
            "store_type" : store_type,
            "inventory" : Singleton.sharedInstance.retailerData.inventory ?? "",
            "payment_method" : Singleton.sharedInstance.retailerData.paymentMethod ?? ""
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.generateOrderByRetailer, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.result?.order_Id ?? 0 ,data.msg!,data.status ?? "")
        }
    }
    
    //MARK: ******************ORDER SUCCESS BY RETAILER******************
    
    func OrderSuccessByRetailer(user_id:String,method_type:String,cart_main_id:String,store_type:String,order_id:String,response_type:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "user_id" : user_id,
            "retailer_id" : Singleton.sharedInstance.retailerData.RetailerId ?? "",
            "method_type" : method_type,
            "vertical" : Singleton.sharedInstance.retailerData.category ?? "",
            "cart_main_id" : cart_main_id,
            "store_type" : store_type,
            "inventory" : Singleton.sharedInstance.retailerData.inventory ?? "",
            "payment_method" : Singleton.sharedInstance.retailerData.paymentMethod ?? "",
            "order_id" : order_id,
            "response_type" : response_type
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.OrderSuccessByRetailer, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status ?? "")
        }
    }
    
    
    //MARK: ******************ADD AND ASSIGN TAXI DATA******************
    
    func addAndAssignTaxiData(setting_type:String,allocation_type:String,to_address:String,title:String,from_latitude:String,create_by:String,number:String,to_longitude:String,from_longitude:String,product_id:String,allocation_id:String,to_latitude:String,location:String,floor:String,from_address:String,completionHandler closure: @escaping(String?,String?) -> Void) {
        let params = [
            "store_id" : Singleton.sharedInstance.retailerData.storeId ?? "",
            "setting_type" : setting_type,
            "allocation_type" : allocation_type,
            "vertical" : Singleton.sharedInstance.retailerData.category ?? "",
            "to_address" : to_address,
            "title" : title,
            "from_latitude" : from_latitude,
            "create_by" : create_by,
            "number" : number,
            "to_longitude" : to_longitude,
            "from_longitude" : from_longitude,
            "product_id" : product_id,
            "allocation_id" : allocation_id,
            "to_latitude" : to_latitude,
            "location" : location,
            "floor" : floor,
            "from_address" : from_address
        ] as [String : Any]
        WebServiceManager.sharedInstance.AFPostRequest(url: EndPoint.addAndAssignTaxiData, parameters: params) { data,error  in
            guard let data:Base = data else{
                return}
            closure(data.msg!,data.status ?? "")
        }
    }
    //    //MARK: **************** CREATE DOCTOR AVAILABILITY POST ********************
    //    func getServiceData <T: Codable> (url: String, method: HTTPMethod, parameters: [String:Any], encodingType: ParameterEncoding, headers:HTTPHeaders, completion: @escaping (T?, String?) ->()) {
    //
    //        if NetworkState.isConnected() {
    //               //print("Network is Reachable")
    //            let manager = AF
    //            manager.session.configuration.timeoutIntervalForRequest = 20
    //            manager.request(url, method: method, parameters: parameters, encoding: encodingType, headers: headers).response { response in
    //
    //                if response.error != nil {
    //                           //debugPrint(response.error?.localizedDescription ?? "")
    //                           completion(nil, response.error?.localizedDescription)
    //                       }
    //                do {
    //                    guard let responsedata = response.data else {return completion(nil, response.error?.localizedDescription)}
    //                    let decoder = JSONDecoder()
    //                  //  let data = try decoder.decode(Base.self, from: responsedata)
    //
    //                    do{
    //                        let returnedResponse = try decoder.decode(T.self, from: responsedata)
    //                        completion(returnedResponse, nil)
    //                    }catch{
    //                        //debugPrint(error)
    //                        completion(nil, error.localizedDescription)
    //                    }
    //                }
    //
    //               }
    //
    //           }else {
    //               //print("Network Not Reachable")
    //               completion(nil, "Network Not Reachable")
    //           }
    //
    //       }
    //
    //
    //    //MARK: -Almofire Image Upload Multipart request
    //    func multipartServiceData <T: Codable> (url: String, method: HTTPMethod,file:UIImage?,fileParameter:String, parameters: [String:Any], encodingType: ParameterEncoding, headers:HTTPHeaders, completion: @escaping (T?, String?) ->()) {
    //        if NetworkState.isConnected() {
    //        let manager = AF
    //        manager.session.configuration.timeoutIntervalForRequest = 20
    //        let api = manager.upload(multipartFormData: { (multipartFormData) in
    //         // print(urlString,parameter)
    //            for (key, value) in parameters
    //            {
    //                if key == fileParameter  && file != nil{
    //                    if let imageData = file!.jpegData(compressionQuality: 0.6) {
    //                       // let base64 = image.conte
    ////                        let data: Data? = image.jpegData(compressionQuality: 0.4)
    ////                        let imageStr = data?.base64EncodedString()
    ////                        print(imageStr)
    //                        multipartFormData.append(imageData, withName: fileParameter, fileName: "file.jpg", mimeType: "image/jpg")
    //                    }
    //                }else{
    //                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
    //                }
    //            }
    //        }, to:url,method: .post,headers: headers)
    //        api.uploadProgress { (Progress) in
    //            print("Upload Progress: \(Progress.fractionCompleted)")
    //        }
    //        api.response { response -> Void in
    //           // print(response.result)
    //            if response.error != nil {
    //                //debugPrint(response.error?.localizedDescription ?? "")
    //                       completion(nil, response.error?.localizedDescription)
    //                   }
    //            do {
    //                guard let responsedata = response.data else {return completion(nil, response.error?.localizedDescription)}
    //                let decoder = JSONDecoder()
    //              //  let data = try decoder.decode(Base.self, from: responsedata)
    //
    //                do{
    //                    let returnedResponse = try decoder.decode(T.self, from: responsedata)
    //                    completion(returnedResponse, nil)
    //                }catch{
    //                    //debugPrint(error)
    //                    completion(nil, error.localizedDescription)
    //                }
    //            }
    //        }
    //        }else {
    //            //print("Network Not Reachable")
    //            completion(nil, "Network Not Reachable")
    //        }
    //    }
    //
    
}
class NetworkState {
    class func isConnected() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
extension WebServiceManager: DropdownActionDelegate{
    func dropdownActionBool(yesClicked: Bool, type: DropdownActionType) {
        if yesClicked{
            if type == .logout{
                Singleton.sharedInstance.retailerData = nil
                if let bundleID = Bundle.main.bundleIdentifier {
                    UserDefaults.standard.removePersistentDomain(forName: bundleID)
                }
                // FTIndicator.showToastMessage(msg!)
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let homeVC = storyboard.instantiateViewController(withIdentifier: "LoginNavi") as! UINavigationController
                let window = UIApplication.shared.keyWindow
                window?.rootViewController = homeVC
                window?.makeKeyAndVisible()
            }else{
                
            }
        }else{
            
        }
    }
}
