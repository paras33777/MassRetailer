//
//  DocAvailSlot.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on August 10, 2022
//
import Foundation

//struct DocAvailSlot: Codable {
//
//	let srarTime: String?
//	let endTime: String?
//
//	private enum CodingKeys: String, CodingKey {
//		case srarTime = "srarTime"
//		case endTime = "endTime"
//	}
//
//	init(from decoder: Decoder) throws {
//		let values = try decoder.container(keyedBy: CodingKeys.self)
//		srarTime = try values.decodeIfPresent(String.self, forKey: .srarTime)
//		endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
//	}
//
//
//
//}
struct DocAvailSlot: Codable {

    let Doctor_availability_fromDate: String?
    let Doctor_availability_starttime: String?
    let Doctor_availability_endtime:String?
    let Doctor_availability_days:String?
    let Doctor_availability_slot_type: String?
    let srarTime: String?
    let endTime:String?
    
    
    private enum CodingKeys: String, CodingKey {
        case Doctor_availability_fromDate = "Doctor_availability_fromDate"
        case Doctor_availability_starttime = "Doctor_availability_starttime"
        case Doctor_availability_endtime = "Doctor_availability_endtime"
        case Doctor_availability_days = "Doctor_availability_days"
        case Doctor_availability_slot_type = "Doctor_availability_slot_type"
        case srarTime = "srarTime"
        case endTime = "endTime"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        Doctor_availability_fromDate = try values.decodeIfPresent(String.self, forKey: .Doctor_availability_fromDate)
        Doctor_availability_starttime = try values.decodeIfPresent(String.self, forKey: .Doctor_availability_starttime)
        Doctor_availability_endtime = try values.decodeIfPresent(String.self, forKey: .Doctor_availability_endtime)
        Doctor_availability_days = try values.decodeIfPresent(String.self, forKey: .Doctor_availability_days)
        Doctor_availability_slot_type = try values.decodeIfPresent(String.self, forKey: .Doctor_availability_slot_type)
        srarTime = try values.decodeIfPresent(String.self, forKey: .srarTime)
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
    }

    

}
