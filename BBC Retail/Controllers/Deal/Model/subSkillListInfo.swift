//
//  subSkillListInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 16/01/23.
//

import Foundation
class SubSkillList : Codable {

    let createdAt : String?
    let id : String?
    let name : String?
    let price : String?
    let productType : String?
    let storeId : String?
    var quantity : String = ""

    enum CodingKeys: String, CodingKey {
        case createdAt = "createdAt"
        case id = "id"
        case name = "name"
        case price = "price"
        case productType = "product_type"
        case storeId = "store_id"
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        productType = try values.decodeIfPresent(String.self, forKey: .productType)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
    }


}
