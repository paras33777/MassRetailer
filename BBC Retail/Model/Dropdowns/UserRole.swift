//
//  UserRole.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 27, 2022
//
import Foundation

class UserRole : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
                let values = try decoder.container(keyedBy: CodingKeys.self)
                name = try values.decodeIfPresent(String.self, forKey: .name)
               value = try values.decodeIfPresent(String.self, forKey: .value)
        }

}
