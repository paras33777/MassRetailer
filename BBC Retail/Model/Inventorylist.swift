//
//  Inventorylist.swift
//  BBC Retail
//
//  Created by Newforce MAC on 28/11/22.
//

import Foundation


struct Inventorylist:Codable{
    let COURSE_NAME:String?
    let quantity: String?
    let standard_price: String?
    let price: String?
    let cost_price:String?
    let status:String?
    let sub_status:String?
    let status_comment:String?
    let create_time:String?
    
    let unit:String?
    
    private enum CodingKeys: String, CodingKey {
        case COURSE_NAME = "COURSE_NAME"
        case quantity = "quantity"
        case standard_price = "standard_price"
        case price = "price"
        case cost_price = "cost_price"
        case status = "status"
        case sub_status = "sub_status"
        case status_comment = "status_comment"
        case create_time = "create_time"
        case unit = "unit"
       
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        COURSE_NAME = try values.decodeIfPresent(String.self, forKey: .COURSE_NAME)
        quantity = try values.decodeIfPresent(String.self, forKey: .quantity)
        standard_price = try values.decodeIfPresent(String.self, forKey: .standard_price)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        cost_price = try values.decodeIfPresent(String.self, forKey: .cost_price)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        sub_status = try values.decodeIfPresent(String.self, forKey: .sub_status)
        status_comment = try values.decodeIfPresent(String.self, forKey: .status_comment)
        create_time = try values.decodeIfPresent(String.self, forKey: .create_time)
        unit = try values.decodeIfPresent(String.self, forKey: .unit)
    }
}

