//
//  DealListInfo.swift
//  BBC Retail
//
//  Created by rupinder singh on 09/01/23.
//

import Foundation
struct DealsModel : Codable {
    
    let status : String?
    let msg : String?
    let result : ResultModel?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case msg = "msg"
        case result = "ResultModel"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        msg = try values.decodeIfPresent(String.self, forKey: .msg)
        result = try values.decodeIfPresent(ResultModel.self, forKey: .result)
    }
}

struct DealList : Codable {
    let dealId : String?
    let storeId : String?
    let salesOrderType : String?
    let userFirstName : String?
    let userLastName : String?
    let userMobile : String?
    let retailerId : String?
    let amount : String?
    let activity : String?
    let productName : String?
    let deliveryDate : String?
    let dealcreatedOn : String?
    let dealStatus : String?
    let dealSubStatus : String?
    let quantity : String?

    enum CodingKeys: String, CodingKey {

        case dealId = "dealId"
        case storeId = "storeId"
        case salesOrderType = "salesOrderType"
        case userFirstName = "userFirstName"
        case userLastName = "userLastName"
        case userMobile = "userMobile"
        case retailerId = "retailerId"
        case amount = "Amount"
        case activity = "activity"
        case productName = "productName"
        case deliveryDate = "deliveryDate"
        case dealcreatedOn = "dealcreatedOn"
        case dealStatus = "dealStatus"
        case dealSubStatus = "dealSubStatus"
        case quantity = "quantity"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dealId = try values.decodeIfPresent(String.self, forKey: .dealId)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        salesOrderType = try values.decodeIfPresent(String.self, forKey: .salesOrderType)
        userFirstName = try values.decodeIfPresent(String.self, forKey: .userFirstName)
        userLastName = try values.decodeIfPresent(String.self, forKey: .userLastName)
        userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
        retailerId = try values.decodeIfPresent(String.self, forKey: .retailerId)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        activity = try values.decodeIfPresent(String.self, forKey: .activity)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        deliveryDate = try values.decodeIfPresent(String.self, forKey: .deliveryDate)
        dealcreatedOn = try values.decodeIfPresent(String.self, forKey: .dealcreatedOn)
        dealStatus = try values.decodeIfPresent(String.self, forKey: .dealStatus)
        dealSubStatus = try values.decodeIfPresent(String.self, forKey: .dealSubStatus)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
    }

}


struct ResultModel : Codable {
    let totalpage : Int?
    let totalCount : Int?
    let dealList : [DealList]?

    enum CodingKeys: String, CodingKey {

        case totalpage = "totalpage"
        case totalCount = "totalCount"
        case dealList = "dealList"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalpage = try values.decodeIfPresent(Int.self, forKey: .totalpage)
        totalCount = try values.decodeIfPresent(Int.self, forKey: .totalCount)
        dealList = try values.decodeIfPresent([DealList].self, forKey: .dealList)
    }

}
