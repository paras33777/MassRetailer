//
//  ProductTaxList.swift
//  BBC Retail
//
//  Created by Newforce MAC on 24/11/22.
//

import Foundation
struct  ProductTaxList:Codable{
    let ID:String?
    let NAME: String?
    let CREATOR: String?
    let PERCENTAGE: String?
    let STATUS:String?
    let RETAILER_ID:String?
    let ADMIN_FULL_NAME:String?
    
    private enum CodingKeys: String, CodingKey {
        case ID = "ID"
        case NAME = "NAME"
        case CREATOR = "CREATOR"
        case PERCENTAGE = "PERCENTAGE"
        case STATUS = "STATUS"
        case RETAILER_ID = "RETAILER_ID"
        case ADMIN_FULL_NAME = "ADMIN_FULL_NAME"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ID = try values.decodeIfPresent(String.self, forKey: .ID)
        NAME = try values.decodeIfPresent(String.self, forKey: .NAME)
        CREATOR = try values.decodeIfPresent(String.self, forKey: .CREATOR)
        PERCENTAGE = try values.decodeIfPresent(String.self, forKey: .PERCENTAGE)
        STATUS = try values.decodeIfPresent(String.self, forKey: .STATUS)
        RETAILER_ID = try values.decodeIfPresent(String.self, forKey: .RETAILER_ID)
        ADMIN_FULL_NAME = try values.decodeIfPresent(String.self, forKey: .ADMIN_FULL_NAME)
    }
}

