//
//  Payments.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 24, 2022
//
import Foundation

struct Payments: Codable {

	let productName: String?
	let time: String?
	let to: String?
	let amount: String?
	let paymentMethod: String?
    let date : String?

	private enum CodingKeys: String, CodingKey {
		case productName = "product_Name"
		case time = "time"
		case to = "to"
		case amount = "amount"
		case paymentMethod = "payment_Method"
        case date = "date"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		productName = try values.decodeIfPresent(String.self, forKey: .productName)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		to = try values.decodeIfPresent(String.self, forKey: .to)
		amount = try values.decodeIfPresent(String.self, forKey: .amount)
		paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
        date = try values.decodeIfPresent(String.self, forKey: .date)
	}

}
