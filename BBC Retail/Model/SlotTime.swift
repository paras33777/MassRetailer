//
//  SlotTime.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on August 10, 2022
//
import Foundation

struct SlotTime: Codable {

	let docAvailSlot: [DocAvailSlot]?
	let bookedSlot: [BookedSlot]?

	private enum CodingKeys: String, CodingKey {
		case docAvailSlot = "DocAvailSlot"
		case bookedSlot = "BookedSlot"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		docAvailSlot = try values.decodeIfPresent([DocAvailSlot].self, forKey: .docAvailSlot)
		bookedSlot = try values.decodeIfPresent([BookedSlot].self, forKey: .bookedSlot)
	}



}
