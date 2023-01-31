//
//  SettlementReport.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 24, 2022
//
import Foundation

struct SettlementReport: Codable {

	let todayNoPayment: String?
	let todayAmount: String?
	let payments: [Payments]?

	private enum CodingKeys: String, CodingKey {
		case todayNoPayment = "today_No_Payment"
		case todayAmount = "today_Amount"
		case payments = "payments"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		todayNoPayment = try values.decodeIfPresent(String.self, forKey: .todayNoPayment)
		todayAmount = try values.decodeIfPresent(String.self, forKey: .todayAmount)
		payments = try values.decodeIfPresent([Payments].self, forKey: .payments)
	}



}
