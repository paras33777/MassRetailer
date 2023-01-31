//
//  StoreList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 27, 2022
//
import Foundation

struct StoreList: Codable {

	let userRole: [UserRole]?
	let paymentMethod: String?
	let category: String?
	let services: String?
	let storeType: String?
	let COD: String?
	let googlepay: String?
	let phonepay: String?
	let paytm: String?
	let storeId: String?
	let storeName: String?
	let storeQrCode: String?
	let storeImageSmal: String?
	let location: String?
	let access: String?
	let settings: String?
	let ADMINID: String?
    var taxStatus :String?
    var taxType :String?
    var taxId :String?
    var taxName :String?
    var taxPercentage :String?
    

	private enum CodingKeys: String, CodingKey {
		case userRole = "userRole"
		case paymentMethod = "paymentMethod"
		case category = "category"
		case services = "services"
		case storeType = "storeType"
		case COD = "COD"
		case googlepay = "googlepay"
		case phonepay = "phonepay"
		case paytm = "paytm"
		case storeId = "storeId"
		case storeName = "storeName"
		case storeQrCode = "storeQrCode"
		case storeImageSmal = "storeImageSmal"
		case location = "location"
		case access = "access"
		case settings = "settings"
		case ADMINID = "ADMIN_ID"
        case taxStatus   = "taxStatus"
        case taxType   = "taxType"
        case taxId   = "taxId"
        case taxName   = "taxName"
        case taxPercentage   = "taxPercentage"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		userRole = try values.decodeIfPresent([UserRole].self, forKey: .userRole)
		paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
		category = try values.decodeIfPresent(String.self, forKey: .category)
		services = try values.decodeIfPresent(String.self, forKey: .services)
		storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
		COD = try values.decodeIfPresent(String.self, forKey: .COD)
		googlepay = try values.decodeIfPresent(String.self, forKey: .googlepay)
		phonepay = try values.decodeIfPresent(String.self, forKey: .phonepay)
		paytm = try values.decodeIfPresent(String.self, forKey: .paytm)
		storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
		storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
		storeQrCode = try values.decodeIfPresent(String.self, forKey: .storeQrCode)
		storeImageSmal = try values.decodeIfPresent(String.self, forKey: .storeImageSmal)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		access = try values.decodeIfPresent(String.self, forKey: .access)
		settings = try values.decodeIfPresent(String.self, forKey: .settings)
		ADMINID = try values.decodeIfPresent(String.self, forKey: .ADMINID)
        taxStatus = try values.decodeIfPresent(String.self, forKey: .taxStatus)
        taxType = try values.decodeIfPresent(String.self, forKey: .taxType)
        taxId = try values.decodeIfPresent(String.self, forKey: .taxId)
        taxName = try values.decodeIfPresent(String.self, forKey: .taxName)
        taxPercentage = try values.decodeIfPresent(String.self, forKey: .taxPercentage)
	}

	
}
