//
//  LoginDevices.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on July 06, 2022
//
import Foundation

struct LoginDevices: Codable {

	let deviceName: String?
	let location: String?
	let lastactivity: String?
	let browerName: String?

	private enum CodingKeys: String, CodingKey {
		case deviceName = "deviceName"
		case location = "location"
		case lastactivity = "lastactivity"
		case browerName = "browerName"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		deviceName = try values.decodeIfPresent(String.self, forKey: .deviceName)
        location = try values.decodeIfPresent(String.self, forKey: .location) ?? ""
		lastactivity = try values.decodeIfPresent(String.self, forKey: .lastactivity)
		browerName = try values.decodeIfPresent(String.self, forKey: .browerName)
	}



}
