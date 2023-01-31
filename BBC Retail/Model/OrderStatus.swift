//
//  OrderStatus.swift
//  BBC Retail
//
//  Created by Himanshu on 20/10/22.
//

import Foundation
class OrderStatus : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
                let values = try decoder.container(keyedBy: CodingKeys.self)
           name = try values.decodeIfPresent(String.self, forKey: .name)
           color = try values.decodeIfPresent(String.self, forKey: .color)
           value = try values.decodeIfPresent(String.self, forKey: .value)
        }

}
