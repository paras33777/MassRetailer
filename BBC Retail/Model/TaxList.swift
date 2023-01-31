//
//  TaxList.swift
//  BBC Retail
//
//  Created by Newforce MAC on 07/12/22.
//

import Foundation

struct TaxList:Codable{
    var TAX_TYPE:String?
    var TAX_ID:String?
    var NAME:String?
    var PERCENTAGE:String?
    
    private enum CodingKeys: String, CodingKey {
        case TAX_TYPE = "TAX_TYPE"
        case TAX_ID = "TAX_ID"
        case NAME = "NAME"
        case PERCENTAGE = "PERCENTAGE"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        TAX_TYPE = try values.decodeIfPresent(String.self, forKey: .TAX_TYPE)
        TAX_ID = try values.decodeIfPresent(String.self, forKey: .TAX_ID)
        NAME = try values.decodeIfPresent(String.self, forKey: .NAME)
        PERCENTAGE = try values.decodeIfPresent(String.self, forKey: .PERCENTAGE)
      
    }
    
    
}
