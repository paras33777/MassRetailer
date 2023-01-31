//
//  DoctorTimingSlot.swift
//  BBC Retail
//
//  Created by Himanshu on 10/10/22.
//

import Foundation

//struct SlotEventsRepeat: Codable {
//
//    let name: String?
//    let value: String?
//
//    private enum CodingKeys: String, CodingKey {
//        case name = "name"
//        case value = "value"
//    }
//
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//        value = try values.decodeIfPresent(String.self, forKey: .value)
//    }
//}

class SlotEventsRepeat : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
                let values = try decoder.container(keyedBy: CodingKeys.self)
           name = try values.decodeIfPresent(String.self, forKey: .name)
           value = try values.decodeIfPresent(String.self, forKey: .value)
        }

}
