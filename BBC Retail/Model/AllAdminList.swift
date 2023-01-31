//
//  AllAdminList.swift
//  BBC Retail
//
//  Created by Newforce MAC on 29/11/22.
//

import Foundation


struct AllAdminList: Codable {
    
    var ADMIN_FULL_NAME:String?
    var RETAILER_QR_CODE: String?
    var retailer_id: String?
    var store_name:String?
    var store_image:String?
    var store_type:String?
    var store_payment_type:String?
    var store_status:String?
    var store_qr_code_id: String?
    var store_location: String?
    var store_time: String?
    var store_lat_points: String?
    var store_long_points: String?
    var created_at: String?
    var updated_at: String?
    var barque_id: String?
    var main_status: String?
    var pin_code: String?
    var SETTING_NAME: String?
    var META_VALUE: String?
    var META_NAME: String?
    var id:String?
   
    
    enum CodingKeys: String, CodingKey {
        case ADMIN_FULL_NAME = "ADMIN_FULL_NAME"
        case RETAILER_QR_CODE = "RETAILER_QR_CODE"
        case retailer_id = "retailer_id"
        case store_name = "store_name"
        case store_image = "store_image"
        case store_type = "store_type"
        case store_payment_type = "store_payment_type"
        case store_status = "store_status"
        case store_qr_code_id = "store_qr_code_id"
        case store_location = "store_location"
        case store_time = "store_time"
        case store_lat_points = "store_lat_points"
        case store_long_points = "store_long_points"
        case created_at = "created_at"
        case updated_at = "updated_at"
        case barque_id = "barque_id"
        case main_status = "main_status"
        case pin_code = "pin_code"
        case SETTING_NAME = "SETTING_NAME"
        case META_VALUE = "META_VALUE"
        case META_NAME = "META_NAME"
        case id = "id"
    }

    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(String.self, forKey: .id)
         ADMIN_FULL_NAME = try values.decodeIfPresent(String.self, forKey: .ADMIN_FULL_NAME)
         RETAILER_QR_CODE = try values.decodeIfPresent(String.self, forKey: .RETAILER_QR_CODE)
         retailer_id = try values.decodeIfPresent(String.self, forKey: .retailer_id)
         store_name = try values.decodeIfPresent(String.self, forKey: .store_name)
         store_image = try values.decodeIfPresent(String.self, forKey: .store_image)
         store_type = try values.decodeIfPresent(String.self, forKey: .store_type)
         store_payment_type = try values.decodeIfPresent(String.self, forKey: .store_payment_type)
         store_status = try values.decodeIfPresent(String.self, forKey: .store_status)
         store_qr_code_id = try values.decodeIfPresent(String.self, forKey: .store_qr_code_id)
         store_location = try values.decodeIfPresent(String.self, forKey: .store_location)
         store_time = try values.decodeIfPresent(String.self, forKey: .store_time)
         store_lat_points = try values.decodeIfPresent(String.self, forKey: .store_lat_points)
         store_long_points = try values.decodeIfPresent(String.self, forKey: .store_long_points)
         created_at = try values.decodeIfPresent(String.self, forKey: .created_at)
         updated_at = try values.decodeIfPresent(String.self, forKey: .updated_at)
         barque_id = try values.decodeIfPresent(String.self, forKey: .barque_id)
         main_status = try values.decodeIfPresent(String.self, forKey: .main_status)
         pin_code = try values.decodeIfPresent(String.self, forKey: .pin_code)
         SETTING_NAME = try values.decodeIfPresent(String.self, forKey: .SETTING_NAME)
         META_VALUE = try values.decodeIfPresent(String.self, forKey: .META_VALUE)
         META_NAME = try values.decodeIfPresent(String.self, forKey: .META_NAME)
    }
}
    
