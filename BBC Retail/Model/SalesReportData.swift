//
//  SalesReportData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 24, 2022
//
import Foundation

struct SalesReportData: Codable {

	let orderid: String?
	let time: String?
	let to: String?
	let amount: String?
	let paymentMethod: String?
	let status: String?

	private enum CodingKeys: String, CodingKey {
		case orderid = "orderid"
		case time = "time"
		case to = "to"
		case amount = "amount"
		case paymentMethod = "payment_Method"
		case status = "status"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		orderid = try values.decodeIfPresent(String.self, forKey: .orderid)
		time = try values.decodeIfPresent(String.self, forKey: .time)
		to = try values.decodeIfPresent(String.self, forKey: .to)
		amount = try values.decodeIfPresent(String.self, forKey: .amount)
		paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
		status = try values.decodeIfPresent(String.self, forKey: .status)
	}

    }
