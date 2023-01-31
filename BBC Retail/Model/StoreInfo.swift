//
//  StoreInfo.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on July 05, 2022
//
import Foundation

struct StoreInfo: Codable {

	let storeId: String?
	let retailerId: String?
	let storeName: String?
	let storeImageSmal: String?
	let storeQrCode: String?
	let settings: String?
	let location: String?
	let retailerName: String?
	let GSTIN: String?
	let contactNumber: String?
	let access: String?
	let paymentMethod: String?
	let category: String?
	let services: String?
	let storeType: String?
	let COD: String?
	let googlepay: String?
	let phonepay: String?
	let paytm: String?

	private enum CodingKeys: String, CodingKey {
		case storeId = "storeId"
		case retailerId = "retailerId"
		case storeName = "storeName"
		case storeImageSmal = "storeImageSmal"
		case storeQrCode = "storeQrCode"
		case settings = "settings"
		case location = "location"
		case retailerName = "retailerName"
		case GSTIN = "GSTIN"
		case contactNumber = "contactNumber"
		case access = "access"
		case paymentMethod = "paymentMethod"
		case category = "category"
		case services = "services"
		case storeType = "storeType"
		case COD = "COD"
		case googlepay = "googlepay"
		case phonepay = "phonepay"
		case paytm = "paytm"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId) ?? ""
        retailerId = try values.decodeIfPresent(String.self, forKey: .retailerId) ?? ""
		storeName = try values.decodeIfPresent(String.self, forKey: .storeName) ?? ""
		storeImageSmal = try values.decodeIfPresent(String.self, forKey: .storeImageSmal) ?? ""
		storeQrCode = try values.decodeIfPresent(String.self, forKey: .storeQrCode) ?? ""
		settings = try values.decodeIfPresent(String.self, forKey: .settings) ?? ""
		location = try values.decodeIfPresent(String.self, forKey: .location) ?? ""
		retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName) ?? ""
		GSTIN = try values.decodeIfPresent(String.self, forKey: .GSTIN) ?? ""
		contactNumber = try values.decodeIfPresent(String.self, forKey: .contactNumber) ?? ""
		access = try values.decodeIfPresent(String.self, forKey: .access) ?? ""
		paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod) ?? ""
		category = try values.decodeIfPresent(String.self, forKey: .category) ?? ""
		services = try values.decodeIfPresent(String.self, forKey: .services) ?? ""
		storeType = try values.decodeIfPresent(String.self, forKey: .storeType) ?? ""
		COD = try values.decodeIfPresent(String.self, forKey: .COD) ?? "disable"
		googlepay = try values.decodeIfPresent(String.self, forKey: .googlepay) ?? "disable"
		phonepay = try values.decodeIfPresent(String.self, forKey: .phonepay) ?? "disable"
		paytm = try values.decodeIfPresent(String.self, forKey: .paytm) ?? "disable"
	    }


}
