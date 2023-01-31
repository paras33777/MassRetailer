
import Foundation

struct OrderInfo: Codable {
    
    let orderId: String?
    let totalAmount: String?
    let paymentMethod: String?
    let paymentId: String?
    let orderdate: String?
    let paymentStatus: String?
    let invoiceLink: String?
    let productList: [Productlist]?
    
    
    
    let orderTime: String
    let cartMainId: String
    let reason: String
    let unit: String
    let storeType: String
    let category: String
    let storePaymentType: String
    let storeTypeImage: String
    let storeName: String
    let retailerName: String
    let userId: String
    let userName: String
    let userMobile: String
    let timestamp: String
    let storeId: String
    let orderType: String
    let Tablenumber: String
    let sub_status: String
    
    let taxAmount:String?
    let GrandTotal:String?
    let currencySymbol: String?
    let currency: String?
    private enum CodingKeys: String, CodingKey {
        case orderId = "orderId"
        case totalAmount = "totalAmount"
        case paymentMethod = "paymentMethod"
        case paymentId = "payment_id"
        case orderdate = "orderdate"
        case paymentStatus = "payment_status"
        case invoiceLink = "invoice_link"
        case productList = "productlist"
        
        case sub_status = "sub_status"
        case orderTime = "orderTime"
        case cartMainId = "cart_main_id"
        case reason = "reason"
        case unit = "unit"
        case storeType = "storeType"
        case category = "category"
        case storePaymentType = "storePaymentType"
        case storeTypeImage = "storeTypeImage"
        case storeName = "storeName"
        case retailerName = "retailerName"
        case userId = "userId"
        case userName = "userName"
        case userMobile = "userMobile"
        case timestamp = "timestamp"
        case storeId = "storeId"
        case orderType = "order_type"
        case Tablenumber = "Tablenumber"
        
        case GrandTotal = "GrandTotal"
        case taxAmount = "taxAmount"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        do {
            let idInt = try values.decodeIfPresent(Int.self, forKey: .totalAmount) ?? 0
            totalAmount = String(idInt)
        } catch DecodingError.typeMismatch {
            totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount) ?? ""
        }
        paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
        paymentId = try values.decodeIfPresent(String.self, forKey: .paymentId)
        orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
        paymentStatus = try values.decodeIfPresent(String.self, forKey: .paymentStatus)
        invoiceLink = try values.decodeIfPresent(String.self, forKey: .invoiceLink)
        productList = try values.decodeIfPresent([Productlist].self, forKey: .productList)
        
        
        orderTime = try values.decode(String.self, forKey: .orderTime)
        cartMainId = try values.decode(String.self, forKey: .cartMainId)
        reason = try values.decode(String.self, forKey: .reason)
        unit = try values.decode(String.self, forKey: .unit)
        storeType = try values.decode(String.self, forKey: .storeType)
        category = try values.decode(String.self, forKey: .category)
        storePaymentType = try values.decode(String.self, forKey: .storePaymentType)
        storeTypeImage = try values.decode(String.self, forKey: .storeTypeImage)
        storeName = try values.decode(String.self, forKey: .storeName)
        retailerName = try values.decode(String.self, forKey: .retailerName)
        userId = try values.decode(String.self, forKey: .userId)
        userName = try values.decode(String.self, forKey: .userName)
        userMobile = try values.decode(String.self, forKey: .userMobile)
        timestamp = try values.decode(String.self, forKey: .timestamp)
        storeId = try values.decode(String.self, forKey: .storeId)
        orderType = try values.decode(String.self, forKey: .orderType)
        Tablenumber = try values.decode(String.self, forKey: .Tablenumber)
        sub_status = try values.decode(String.self, forKey: .sub_status)
        
        taxAmount = try values.decode(String.self, forKey: .taxAmount)
        GrandTotal = try values.decode(String.self, forKey: .GrandTotal)
        
        
        let name =  try values.decodeIfPresent(String.self, forKey: .storeName)
        currency = extarctCurrency(str: name ?? "", type: "currency")
        currencySymbol = getSymbol(forCurrencyCode: currency ?? "INR")
        
        
        func getSymbol(forCurrencyCode code: String) -> String? {
            let locale = NSLocale(localeIdentifier: code)
            
            if locale.displayName(forKey: .currencySymbol, value: code) == code {
                let newlocale = NSLocale(localeIdentifier: code.dropLast() + "_en")
                return newlocale.displayName(forKey: .currencySymbol, value: code)
            }
            return locale.displayName(forKey: .currencySymbol, value: code)
        }
        
        func extarctCurrency(str :String ,type:String) -> String{
            var string = str.components(separatedBy: " ")
            if type == "currency"{
                let currency = string.last
                return currency ?? ""
            }else{
                let name = string.removeLast()
                return string.joined(separator: " ")
            }
        }
    }
}

struct OrderDataInfo: Codable {
    
   
   
//    let paymentMethod: String?
//    let paymentId: String?
//    let orderdate: String?
//    let paymentStatus: String?
//    let invoiceLink: String?
    let productList: [Productlist]?
    let orderId: String?
    let totalAmount: String?
    let cart_main_id : String?
    let storeType : String?
    let category : String?
    
    
    
//    let orderTime: String
//    let cartMainId: String
//    let reason: String
//    let unit: String
//    let storeType: String
//    let category: String
//    let storePaymentType: String
//    let storeTypeImage: String
//    let storeName: String
//    let retailerName: String
//    let userId: String
//    let userName: String
//    let userMobile: String
//    let timestamp: String
//    let storeId: String
//    let orderType: String
//    let Tablenumber: String
//
    
    private enum CodingKeys: String, CodingKey {
        case orderId = "orderId"
        case totalAmount = "totalAmount"
        case productList = "productlist"
        case cart_main_id = "cart_main_id"
        case storeType = "storeType"
        case category = "category"
//        case orderTime = "orderTime"
//        case cartMainId = "cart_main_id"
//        case reason = "reason"
//        case unit = "unit"
//        case storeType = "storeType"
//        case category = "category"
//        case storePaymentType = "storePaymentType"
//        case storeTypeImage = "storeTypeImage"
//        case storeName = "storeName"
//        case retailerName = "retailerName"
//        case userId = "userId"
//        case userName = "userName"
//        case userMobile = "userMobile"
//        case timestamp = "timestamp"
//        case storeId = "storeId"
//        case orderType = "order_type"
//        case Tablenumber = "Tablenumber"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        do {
            let idInt = try values.decodeIfPresent(Int.self, forKey: .totalAmount) ?? 0
            totalAmount = String(idInt)
        } catch DecodingError.typeMismatch {
            totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount) ?? ""
        }
        cart_main_id = try values.decodeIfPresent(String.self, forKey: .cart_main_id)
        storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        productList = try values.decodeIfPresent([Productlist].self, forKey: .productList)
        
        
//        orderTime = try values.decode(String.self, forKey: .orderTime)
//        cartMainId = try values.decode(String.self, forKey: .cartMainId)
//        reason = try values.decode(String.self, forKey: .reason)
//        unit = try values.decode(String.self, forKey: .unit)
//        storeType = try values.decode(String.self, forKey: .storeType)
//        category = try values.decode(String.self, forKey: .category)
//        storePaymentType = try values.decode(String.self, forKey: .storePaymentType)
//        storeTypeImage = try values.decode(String.self, forKey: .storeTypeImage)
//        storeName = try values.decode(String.self, forKey: .storeName)
//        retailerName = try values.decode(String.self, forKey: .retailerName)
//        userId = try values.decode(String.self, forKey: .userId)
//        userName = try values.decode(String.self, forKey: .userName)
//        userMobile = try values.decode(String.self, forKey: .userMobile)
//        timestamp = try values.decode(String.self, forKey: .timestamp)
//        storeId = try values.decode(String.self, forKey: .storeId)
//        orderType = try values.decode(String.self, forKey: .orderType)
//        Tablenumber = try values.decode(String.self, forKey: .Tablenumber)
    }
}
