//
//  BookedSlot.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on August 10, 2022
//
import Foundation

struct BookedSlot: Codable {

	let serviceName: String?
	let srarTime: String?
	let endTime: String?
	let status: String?
    let OrderId : String?

	private enum CodingKeys: String, CodingKey {
		case serviceName = "Servicename"
		case srarTime = "Time"
		case endTime = "EndTime"
		case status = "status"
        case OrderId = "OrderId"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		serviceName = try values.decodeIfPresent(String.self, forKey: .serviceName)
		srarTime = try values.decodeIfPresent(String.self, forKey: .srarTime)
		endTime = try values.decodeIfPresent(String.self, forKey: .endTime)
		status = try values.decodeIfPresent(String.self, forKey: .status)
        OrderId = try values.decodeIfPresent(String.self, forKey: .OrderId)
	}
}
