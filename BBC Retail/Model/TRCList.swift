//
//  TRCList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on July 28, 2022
//
import Foundation

struct TRCList: Codable {

	let trcstoreId: String?
	let title: String?
	let location: String?
	let barcode: String?
	let floor: String?
	let number: String?
	let productId: String?
	let productName: String?
	let mainCategoryName: String?
	let mainCategoryId: String?
	let childCategoryId: String?
	let childCategoryName: String?
	let workerName: String?
	let allocationId: String?
	let trcAllocationId: String?
	let trcStatus: String?
	let allocationStatus: String?
	let allocationType: String?
	let storeId: String?

	private enum CodingKeys: String, CodingKey {
		case trcstoreId = "trcstore_Id"
		case title = "title"
		case location = "location"
		case barcode = "barcode"
		case floor = "floor"
		case number = "number"
		case productId = "product_id"
		case productName = "product_name"
		case mainCategoryName = "main_category_name"
		case mainCategoryId = "main_category_id"
		case childCategoryId = "child_category_id"
		case childCategoryName = "child_category_name"
		case workerName = "worker_name"
		case allocationId = "allocation_id"
		case trcAllocationId = "trc_allocation_id"
		case trcStatus = "trcStatus"
		case allocationStatus = "allocationStatus"
		case allocationType = "allocationType"
		case storeId = "store_id"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		trcstoreId = try values.decodeIfPresent(String.self, forKey: .trcstoreId)
		title = try values.decodeIfPresent(String.self, forKey: .title)
		location = try values.decodeIfPresent(String.self, forKey: .location)
		barcode = try values.decodeIfPresent(String.self, forKey: .barcode)
		floor = try values.decodeIfPresent(String.self, forKey: .floor)
		number = try values.decodeIfPresent(String.self, forKey: .number)
		productId = try values.decodeIfPresent(String.self, forKey: .productId)
		productName = try values.decodeIfPresent(String.self, forKey: .productName)
		mainCategoryName = try values.decodeIfPresent(String.self, forKey: .mainCategoryName)
		mainCategoryId = try values.decodeIfPresent(String.self, forKey: .mainCategoryId)
		childCategoryId = try values.decodeIfPresent(String.self, forKey: .childCategoryId)
		childCategoryName = try values.decodeIfPresent(String.self, forKey: .childCategoryName)
		workerName = try values.decodeIfPresent(String.self, forKey: .workerName)
		allocationId = try values.decodeIfPresent(String.self, forKey: .allocationId)
		trcAllocationId = try values.decodeIfPresent(String.self, forKey: .trcAllocationId)
		trcStatus = try values.decodeIfPresent(String.self, forKey: .trcStatus)
		allocationStatus = try values.decodeIfPresent(String.self, forKey: .allocationStatus)
		allocationType = try values.decodeIfPresent(String.self, forKey: .allocationType)
		storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
	}

}
