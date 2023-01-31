//
//  OrderStatusType.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 14/07/22.
//

import Foundation
class OrderStatusType : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decodeIfPresent(String.self, forKey: .name)
           value = try values.decodeIfPresent(String.self, forKey: .name)
           color = try values.decodeIfPresent(String.self, forKey: .color)
    }
}
