//
//  DealDetailInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 05/01/23.
//

import Foundation
struct SalesOrderDetail : Codable {

    let amount : String?
        let bom : String?
        let dealId : String?
        let dealStatus : String?
        let dealSubStatus : String?
        let dealcreatedOn : String?
        let deliveryDate : String?
        let mobileCode : String?
        let productName : String?
        let quantity : String?
        let retailerId : String?
        let salesOrderType : String?
        let serviceGroup : String?
        let storeName : String?
        let subSkillsList : [SubSkillsList]?
        let userCreatedOn : String?
        let userEmail : String?
        let userFirstName : String?
        let userId : String?
        let userLastName : String?
        let userMobile : String?


        enum CodingKeys: String, CodingKey {
            case amount = "Amount"
            case bom = "bom"
            case dealId = "dealId"
            case dealStatus = "dealStatus"
            case dealSubStatus = "dealSubStatus"
            case dealcreatedOn = "dealcreatedOn"
            case deliveryDate = "deliveryDate"
            case mobileCode = "mobileCode"
            case productName = "productName"
            case quantity = "quantity"
            case retailerId = "retailerId"
            case salesOrderType = "salesOrderType"
            case serviceGroup = "serviceGroup"
            case storeName = "storeName"
            case subSkillsList = "subSkillsList"
            case userCreatedOn = "userCreatedOn"
            case userEmail = "userEmail"
            case userFirstName = "userFirstName"
            case userId = "userId"
            case userLastName = "userLastName"
            case userMobile = "userMobile"
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            amount = try values.decodeIfPresent(String.self, forKey: .amount)
            bom = try values.decodeIfPresent(String.self, forKey: .bom)
            dealId = try values.decodeIfPresent(String.self, forKey: .dealId)
            dealStatus = try values.decodeIfPresent(String.self, forKey: .dealStatus)
            dealSubStatus = try values.decodeIfPresent(String.self, forKey: .dealSubStatus)
            dealcreatedOn = try values.decodeIfPresent(String.self, forKey: .dealcreatedOn)
            deliveryDate = try values.decodeIfPresent(String.self, forKey: .deliveryDate)
            mobileCode = try values.decodeIfPresent(String.self, forKey: .mobileCode)
            productName = try values.decodeIfPresent(String.self, forKey: .productName)
            quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
            retailerId = try values.decodeIfPresent(String.self, forKey: .retailerId)
            salesOrderType = try values.decodeIfPresent(String.self, forKey: .salesOrderType)
            serviceGroup = try values.decodeIfPresent(String.self, forKey: .serviceGroup)
            storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
            subSkillsList = try values.decodeIfPresent([SubSkillsList].self, forKey: .subSkillsList)
            userCreatedOn = try values.decodeIfPresent(String.self, forKey: .userCreatedOn)
            userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
            userFirstName = try values.decodeIfPresent(String.self, forKey: .userFirstName)
            userId = try values.decodeIfPresent(String.self, forKey: .userId)
            userLastName = try values.decodeIfPresent(String.self, forKey: .userLastName)
            userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
        }


    }
struct SubSkillsList : Codable {

    let id : String?
    let name : String?
    let price : String?
    let quantity : String?


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case price = "price"
        case quantity = "quantity"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
    }


}
