//
//  SettlementData.swift
//  BBC Retail
//
//  Created by Newforce MAC on 07/12/22.
//

import Foundation

struct SettlementData : Codable {

    let accountId : String?
    let currency : String?
    let orderDetail : [OrderDetail]?
    let stripeBalance : Int?
    let totalAmount : Int?


    enum CodingKeys: String, CodingKey {
        case accountId = "account_id"
        case currency = "currency"
        case orderDetail = "orderDetail"
        case stripeBalance = "stripeBalance"
        case totalAmount = "totalAmount"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accountId = try values.decodeIfPresent(String.self, forKey: .accountId)
        currency = try values.decodeIfPresent(String.self, forKey: .currency)
        orderDetail = try values.decodeIfPresent([OrderDetail].self, forKey: .orderDetail)
        stripeBalance = try values.decodeIfPresent(Int.self, forKey: .stripeBalance)
        totalAmount = try values.decodeIfPresent(Int.self, forKey: .totalAmount)
    }


}
struct OrderDetail : Codable {

    let amount : String?
    let id : String?
    let transactionId : String?
    let paymentTime : String?
    

    enum CodingKeys: String, CodingKey {
        case amount = "amount"
        case id = "id"
        case transactionId = "transaction_id"
        case paymentTime = "paymentTime"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
        paymentTime = try values.decodeIfPresent(String.self, forKey: .paymentTime)
        
    }


}

