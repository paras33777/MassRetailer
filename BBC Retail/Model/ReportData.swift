//
//  ReportData.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 24, 2022
//
import Foundation

struct ReportData: Codable {

	let totalOrder: String?
	let totalSales: String?
	let inventoryInStock: String?
	let inventoryOutStock: String?
	let footfall: String?

	private enum CodingKeys: String, CodingKey {
		case totalOrder = "totalOrder"
		case totalSales = "totalSales"
		case inventoryInStock = "inventoryInStock"
		case inventoryOutStock = "inventoryOutStock"
		case footfall = "footfall"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		totalOrder = try values.decodeIfPresent(String.self, forKey: .totalOrder)
		totalSales = try values.decodeIfPresent(String.self, forKey: .totalSales)
		inventoryInStock = try values.decodeIfPresent(String.self, forKey: .inventoryInStock)
		inventoryOutStock = try values.decodeIfPresent(String.self, forKey: .inventoryOutStock)
		footfall = try values.decodeIfPresent(String.self, forKey: .footfall)
	}



}
