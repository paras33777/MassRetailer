//
//  GetManfacturingStatusList.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/01/23.
//

import Foundation
class ManufacturingSubStatuslist : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decodeIfPresent(String.self, forKey: .name)
           value = try values.decodeIfPresent(String.self, forKey: .name)
           color = try values.decodeIfPresent(String.self, forKey: .color)
    }
}
class ManufacturingStatuslist : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            name = try values.decodeIfPresent(String.self, forKey: .name)
           value = try values.decodeIfPresent(String.self, forKey: .name)
           color = try values.decodeIfPresent(String.self, forKey: .color)
    }
}
