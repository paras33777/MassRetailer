//
//  workOrderListInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/01/23.
//

import Foundation

struct WorkOrderList : Codable {

    let products : String?
    let orderId : String?
    let orderTime : String?
    let orderdate : String?
    let quantity : String?
    let retailerName : String?
    let salesOrderType : String?
    let status : String?
    let storeId : String?
    let storeName : String?
    let subStatus : String?
    let timestamp : String?
    let totalAmount : String?
    let userMobile : String?
    let userName : String?


    enum CodingKeys: String, CodingKey {
        case products = "Products"
        case orderId = "orderId"
        case orderTime = "orderTime"
        case orderdate = "orderdate"
        case quantity = "quantity"
        case retailerName = "retailerName"
        case salesOrderType = "salesOrderType"
        case status = "status"
        case storeId = "storeId"
        case storeName = "storeName"
        case subStatus = "sub_status"
        case timestamp = "timestamp"
        case totalAmount = "totalAmount"
        case userMobile = "userMobile"
        case userName = "userName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        products = try values.decodeIfPresent(String.self, forKey: .products)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
        orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName)
        salesOrderType = try values.decodeIfPresent(String.self, forKey: .salesOrderType)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
        subStatus = try values.decodeIfPresent(String.self, forKey: .subStatus)
        timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
        totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
        userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
        userName = try values.decodeIfPresent(String.self, forKey: .userName)
    }


}
