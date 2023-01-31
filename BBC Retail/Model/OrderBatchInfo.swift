//
//  OrderBatchInfo.swift
//  BBC Retail
//
//  Created by Himanshu on 19/10/22.
//

import Foundation
struct OrderBatchInfo: Codable {
    


    let orderId: String?
    let totalAmount: String?
    let paymentMethod: String?
    let paymentId: String?
    let orderdate: String?
    let paymentStatus: String?
    let invoiceLink: String?
    let reason: String?
    let subStatus:String?
    let userName : String?
    let cartMainId : String?
    let userMobile : String?
    let userId : String?
    let storeType : String?
    let category : String?
    let storePaymentType : String?
    let retailerName : String?
    let productList: [Productlist]?
    let orderData : [OrderData]?
    let storeId : String?
    let order_type : String?
    let table_id : String?
    let order_batch_id : String?
    
    private enum CodingKeys: String, CodingKey {
        case orderId = "orderId"
        case totalAmount = "totalAmount"
        case paymentMethod = "paymentMethod"
        case paymentId = "payment_id"
        case orderdate = "orderdate"
        case paymentStatus = "payment_status"
        case invoiceLink = "invoice_link"
        case orderData = "orderData"
        case productList = "productlist"
        case cartMainId = "cart_main_id"
        case reason = "reason"
        case subStatus = "sub_status"
        case userName = "userName"
        case userMobile = "userMobile"
        case userId = "userId"
        case storeType = "storeType"
        case category = "category"
        case storePaymentType = "storePaymentType"
        case retailerName = "retailerName"
        case storeId = "storeId"
        case order_type = "order_type"
        case table_id = "table_id"
        case order_batch_id = "order_batch_id"
      }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        do {
            let idInt = try values.decodeIfPresent(Int.self, forKey: .totalAmount) ?? 0
            totalAmount = String(idInt )
        } catch DecodingError.typeMismatch {
            totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount) ?? ""
        }
        paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
        paymentId = try values.decodeIfPresent(String.self, forKey: .paymentId)
        orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
        paymentStatus = try values.decodeIfPresent(String.self, forKey: .paymentStatus)
        invoiceLink = try values.decodeIfPresent(String.self, forKey: .invoiceLink)
        productList = try values.decodeIfPresent([Productlist].self, forKey: .productList)
        cartMainId = try values.decodeIfPresent(String.self, forKey: .cartMainId)
        reason = try values.decodeIfPresent(String.self, forKey: .reason)
        subStatus = try values.decodeIfPresent(String.self, forKey: .subStatus)
        orderData = try values.decodeIfPresent([OrderData].self, forKey: .orderData)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
        userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
        category = try values.decodeIfPresent(String.self, forKey: .category)
        storePaymentType = try values.decodeIfPresent(String.self, forKey: .storePaymentType)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        order_type = try values.decodeIfPresent(String.self, forKey: .order_type)
        table_id = try values.decodeIfPresent(String.self, forKey: .table_id)
        order_batch_id = try values.decodeIfPresent(String.self, forKey: .order_batch_id)
        retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName)
    }
}
struct OrderData: Codable {

    let invoiceLink: String?
    let orderInfo: OrderDataInfo?

    private enum CodingKeys: String, CodingKey {
        case invoiceLink = "invoice_link"
        case orderInfo = "orderInfo"
      
      }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        invoiceLink = try values.decodeIfPresent(String.self, forKey: .invoiceLink)
        orderInfo = try values.decodeIfPresent(OrderDataInfo.self, forKey: .orderInfo)
    }
}





