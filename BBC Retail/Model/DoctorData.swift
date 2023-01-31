//
//  DoctorData.swift
//  BBC Retail
//
//  Created by Himanshu on 10/10/22.
//

import Foundation

class DoctorData : DropDownModel {

       required init(from decoder: Decoder) throws {
        try super.init(from: decoder)
                let values = try decoder.container(keyedBy: CodingKeys.self)
           doctor_id = try values.decodeIfPresent(String.self, forKey: .doctor_id)
           doctor_name = try values.decodeIfPresent(String.self, forKey: .doctor_name)
           position = try values.decodeIfPresent(String.self, forKey: .position)
        }

}
