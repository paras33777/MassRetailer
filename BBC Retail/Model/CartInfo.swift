//
//  CartInfo.swift
//  BBC Retail
//
//  Created by Himanshu on 10/11/22.
//

import Foundation

struct CartInfo: Codable {
   
    let totalQty: String?
    let totalAmount: String?
//    let mainCartId: Int?
        
    let cartMainid: String?
    
    private enum CodingKeys: String, CodingKey {
        case totalQty = "totalQty"
        case totalAmount = "totalAmount"
//        case mainCartId = "mainCartId"
        case cartMainid = "cartMainid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        totalQty = try values.decodeIfPresent(String.self, forKey: .totalQty)
//        mainCartId = try values.decodeIfPresent(Int.self, forKey: .mainCartId)
        totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
        cartMainid = try values.decodeIfPresent(String.self, forKey: .cartMainid)
    }
}
