//
//  ManufacturingWorkOrderDetail.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 13/01/23.
//

import Foundation
struct ManfacturingWorkOrderListInfo : Codable {

    let productIconImage : String?
    let cartMainId : String?
    let currency : String?
    let dealId : String?
    let invoiceLink : String?
    let orderId : String?
    let orderStatus : String?
    let orderTime : String?
    let orderdate : String?
    let productImage : String?
    let productMediumImage : String?
    let productName : String?
    let quantity : String?
    let retailerName : String?
    let salesOrderType : String?
    let storeId : String?
    let storeName : String?
    let storeType : String?
    let subSkillsList : [SubSkillsList]?
    let subStatus : String?
    let timestamp : String?
    let totalAmount : String?
    let userEmail : String?
    let userId : String?
    let userMobile : String?
    let userMobileCode : String?
    let userName : String?


    enum CodingKeys: String, CodingKey {
        case productIconImage = "ProductIconImage"
        case cartMainId = "cart_main_id"
        case currency = "currency"
        case dealId = "dealId"
        case invoiceLink = "invoice_link"
        case orderId = "orderId"
        case orderStatus = "orderStatus"
        case orderTime = "orderTime"
        case orderdate = "orderdate"
        case productImage = "productImage"
        case productMediumImage = "productMediumImage"
        case productName = "productName"
        case quantity = "quantity"
        case retailerName = "retailerName"
        case salesOrderType = "salesOrderType"
        case storeId = "storeId"
        case storeName = "storeName"
        case storeType = "storeType"
        case subSkillsList = "subSkillsList"
        case subStatus = "sub_status"
        case timestamp = "timestamp"
        case totalAmount = "totalAmount"
        case userEmail = "userEmail"
        case userId = "userId"
        case userMobile = "userMobile"
        case userMobileCode = "userMobileCode"
        case userName = "userName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productIconImage = try values.decodeIfPresent(String.self, forKey: .productIconImage)
        cartMainId = try values.decodeIfPresent(String.self, forKey: .cartMainId)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        dealId = try values.decodeIfPresent(String.self, forKey: .dealId)
        invoiceLink = try values.decodeIfPresent(String.self, forKey: .invoiceLink)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderStatus = try values.decodeIfPresent(String.self, forKey: .orderStatus)
        orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
        productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
        productMediumImage = try values.decodeIfPresent(String.self, forKey: .productMediumImage)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName)
        salesOrderType = try values.decodeIfPresent(String.self, forKey: .salesOrderType)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
        storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
        subSkillsList = try values.decodeIfPresent([SubSkillsList].self, forKey: .subSkillsList)
        subStatus = try values.decodeIfPresent(String.self, forKey: .subStatus)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
        userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
        userId = try values.decodeIfPresent(String.self, forKey: .userId)
        userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
        userMobileCode = try values.decodeIfPresent(String.self, forKey: .userMobileCode)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }


}
