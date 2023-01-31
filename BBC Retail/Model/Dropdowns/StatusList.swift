//
//  StatusList.swift
//  BBC Retail
//
//  Created by Newforce MAC on 28/11/22.
//

import Foundation


class StatusList : DropDownModel {
    
    required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        value = try values.decodeIfPresent(String.self, forKey: .value)
    }
}
