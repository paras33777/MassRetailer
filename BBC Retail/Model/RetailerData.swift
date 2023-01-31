//
//  RetailerData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on April 12, 2022
//
import Foundation

struct RetailerData: Codable {

        let RetailerId: String?
        let ADMINID: String?
        let ADMINFIRSTNAME: String?
        let ADMINLASTNAME: String?
        var StoreName: String?
        let ADMINEMAIL: String?
        let ADMINNAME: String?
        let ADMINURINAME: String?
        let ADMINMOBILE: String?
        let CITYNAME: String?
        let ADMINADDRESS: String?
        let ADMINZIPCODE: String?
        let ADMINAVATAR: String?
        let ADMINTYPE: String?
        let GSTNUMBER: String?
        var RETAILERQRCODE: String?
    var storeId: String?
    var access: String?
    var storeType: String?
    var settings: String?
    var paymentMethod: String?
    var category: String?
    var services: String?
    var COD: String?
    var googlepay: String?
    var phonepay: String?
    var paytm: String?
    var contactNumber: String?
    let ADMINPAN :String?
    let ADMINSTATUS :String?
    let accessKeyPID :String?
    let accessKey :String?
    let accessToken :String?
    let inventory :String?
    let merchantUpiId :String?
    let merchantName :String?
    let merchantCode :String?
    let merchantType :String?


    var storeQrCode :String?
    var storeImageSmal :String?
    var location :String?
    var userRole: [UserRole]?
    var selectedStoreCurrency : String?
        
    var taxStatus :String?
    var taxType :String?
    var taxId :String?
    var taxName :String?
    var taxPercentage :String?
        

        private enum CodingKeys: String, CodingKey {
            case RetailerId = "Retailer_id"
            case ADMINID = "ADMIN_ID"
            case ADMINFIRSTNAME = "ADMIN_FIRST_NAME"
            case ADMINLASTNAME = "ADMIN_LAST_NAME"
            case StoreName = "StoreName"
            case ADMINEMAIL = "ADMIN_EMAIL"
            case ADMINNAME = "ADMIN_NAME"
            case ADMINURINAME = "ADMIN_URI_NAME"
            case ADMINMOBILE = "ADMIN_MOBILE"
            case CITYNAME = "CITY_NAME"
            case ADMINADDRESS = "ADMIN_ADDRESS"
            case ADMINZIPCODE = "ADMIN_ZIP_CODE"
            case ADMINAVATAR = "ADMIN_AVATAR"
            case ADMINTYPE = "ADMIN_TYPE"
            case GSTNUMBER = "GST_NUMBER"
            case RETAILERQRCODE = "RETAILER_QR_CODE"
            case storeId = "store_id"
            case access = "access"
            case storeType = "storeType"
            case settings = "settings"
            case paymentMethod = "paymentMethod"
            case category = "category"
            case services = "services"
            case COD = "COD"
            case googlepay = "googlepay"
            case phonepay = "phonepay"
            case paytm = "paytm"
            case storeImageSmal = "storeImageSmal"
            case location = "location"
            case userRole = "userRole"
            case contactNumber = "contactNumber"
            case selectedStoreCurrency = "selectedStoreCurrency"
        
            
            case ADMINPAN       = "ADMIN_PAN"
            case ADMINSTATUS    = "ADMIN_STATUS"
            case accessKeyPID   = "accessKeyPID"
            case accessKey      = "accessKey"
            case accessToken    = "accessToken"
            case inventory      = "inventory"
            case merchantUpiId  = "merchantUpiId"
            case merchantName   = "merchantName"
            case merchantCode   = "merchantCode"
            case merchantType   = "merchantType"
           
            case taxStatus   = "taxStatus"
            case taxType   = "taxType"
            case taxId   = "taxId"
            case taxName   = "taxName"
            case taxPercentage   = "taxPercentage"
           
          
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {
                let id = try values.decodeIfPresent(Int.self, forKey: .RetailerId)
                 RetailerId = id == 0 ? nil : String(id ?? 0)
               } catch DecodingError.typeMismatch {
                RetailerId = try values.decodeIfPresent(String.self, forKey: .RetailerId) ?? ""
               }
            ADMINID = try values.decodeIfPresent(String.self, forKey: .ADMINID)
            ADMINFIRSTNAME = try values.decodeIfPresent(String.self, forKey: .ADMINFIRSTNAME)
            ADMINLASTNAME = try values.decodeIfPresent(String.self, forKey: .ADMINLASTNAME)
            StoreName = try values.decodeIfPresent(String.self, forKey: .StoreName)
            ADMINEMAIL = try values.decodeIfPresent(String.self, forKey: .ADMINEMAIL)
            ADMINNAME = try values.decodeIfPresent(String.self, forKey: .ADMINNAME)
            ADMINURINAME = try values.decodeIfPresent(String.self, forKey: .ADMINURINAME)
            ADMINMOBILE = try values.decodeIfPresent(String.self, forKey: .ADMINMOBILE)
            CITYNAME = try values.decodeIfPresent(String.self, forKey: .CITYNAME)
            ADMINADDRESS = try values.decodeIfPresent(String.self, forKey: .ADMINADDRESS)
            ADMINZIPCODE = try values.decodeIfPresent(String.self, forKey: .ADMINZIPCODE)
            ADMINAVATAR = try values.decodeIfPresent(String.self, forKey: .ADMINAVATAR)
            ADMINTYPE = try values.decodeIfPresent(String.self, forKey: .ADMINTYPE)
            GSTNUMBER = try values.decodeIfPresent(String.self, forKey: .GSTNUMBER)
            RETAILERQRCODE = try values.decodeIfPresent(String.self, forKey: .RETAILERQRCODE)
            storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
            access = try values.decodeIfPresent(String.self, forKey: .access)
            storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
            settings = try values.decodeIfPresent(String.self, forKey: .settings)
            paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
            category = try values.decodeIfPresent(String.self, forKey: .category)
            services = try values.decodeIfPresent(String.self, forKey: .services)
            COD = try values.decodeIfPresent(String.self, forKey: .COD) ?? "disable"
            googlepay = try values.decodeIfPresent(String.self, forKey: .googlepay) ?? "disable"
            phonepay = try values.decodeIfPresent(String.self, forKey: .phonepay) ?? "disable"
            paytm = try values.decodeIfPresent(String.self, forKey: .paytm) ?? "disable"
            
            ADMINPAN  = try values.decodeIfPresent(String.self, forKey: .ADMINPAN) ?? ""
            ADMINSTATUS = try values.decodeIfPresent(String.self, forKey: .ADMINSTATUS) ?? ""
            accessKeyPID = try values.decodeIfPresent(String.self, forKey: .accessKeyPID) ?? ""
            accessKey = try values.decodeIfPresent(String.self, forKey: .accessKey) ?? ""
            accessToken = try values.decodeIfPresent(String.self, forKey: .accessToken) ?? ""
            inventory = try values.decodeIfPresent(String.self, forKey: .inventory) ?? ""
            merchantUpiId = try values.decodeIfPresent(String.self, forKey: .merchantUpiId) ?? ""
            merchantName = try values.decodeIfPresent(String.self, forKey: .merchantName) ?? ""
            merchantCode = try values.decodeIfPresent(String.self, forKey: .merchantCode) ?? ""
            merchantType = try values.decodeIfPresent(String.self, forKey: .merchantType) ?? ""
            
            storeImageSmal = try values.decodeIfPresent(String.self, forKey: .storeImageSmal)
            storeImageSmal = ""
            location = try values.decodeIfPresent(String.self, forKey: .location)
            userRole = try values.decodeIfPresent([UserRole].self, forKey: .userRole)
            selectedStoreCurrency = try values.decodeIfPresent(String.self, forKey: .selectedStoreCurrency)
            
            taxStatus = try values.decodeIfPresent(String.self, forKey: .taxStatus)
            taxType = try values.decodeIfPresent(String.self, forKey: .taxType)
            taxId = try values.decodeIfPresent(String.self, forKey: .taxId)
            taxName = try values.decodeIfPresent(String.self, forKey: .taxName)
            taxPercentage = try values.decodeIfPresent(String.self, forKey: .taxPercentage)
 
 
        }

}
	
enum Vertical: String, Codable {
   case blue, red, green, yellow, pink, purple
}
