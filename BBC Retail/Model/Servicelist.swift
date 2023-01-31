//
//  Servicelist.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on June 30, 2022
//
import Foundation

struct Servicelist: Codable {

	let ProductId: String?
	let ProductName: String?
	let MainCategory: String?
	let MAINCATEGORYID: String?
	let CHILDCATEGORYNAME: String?
	let CHILDCATEGORYID: String?
	let ProductImage: String?
	let HalfPrice: String?
	let FullPrice: String?
	let CostPrice: String?
	let SKU: String?
	let ProductSHORTDESCRIPTION: String?
	let ProductDETAIL: String?
	let StoreName: String?
	let RetailerId: String?
	let StoreId: String?
	let ProductMediumImage: String?
	let ProductIconImage: String?
	let productType: String?

	private enum CodingKeys: String, CodingKey {
		case ProductId = "Product_id"
		case ProductName = "Product_Name"
		case MainCategory = "Main_Category"
		case MAINCATEGORYID = "MAIN_CATEGORY_ID"
		case CHILDCATEGORYNAME = "CHILD_CATEGORY_NAME"
		case CHILDCATEGORYID = "CHILD_CATEGORY_ID"
		case ProductImage = "Product_Image"
		case HalfPrice = "Half_Price"
		case FullPrice = "Full_Price"
		case CostPrice = "Cost_Price"
		case SKU = "SKU"
		case ProductSHORTDESCRIPTION = "Product_SHORT_DESCRIPTION"
		case ProductDETAIL = "Product_DETAIL"
		case StoreName = "Store_Name"
		case RetailerId = "Retailer_Id"
		case StoreId = "Store_Id"
		case ProductMediumImage = "Product_Medium_Image"
		case ProductIconImage = "Product_Icon_Image"
		case productType = "product_type"
	}

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		ProductId = try values.decodeIfPresent(String.self, forKey: .ProductId)
		ProductName = try values.decodeIfPresent(String.self, forKey: .ProductName)
		MainCategory = try values.decodeIfPresent(String.self, forKey: .MainCategory) ?? ""
		MAINCATEGORYID = try values.decodeIfPresent(String.self, forKey: .MAINCATEGORYID) ?? ""
		CHILDCATEGORYNAME = try values.decodeIfPresent(String.self, forKey: .CHILDCATEGORYNAME)
		CHILDCATEGORYID = try values.decodeIfPresent(String.self, forKey: .CHILDCATEGORYID)
		ProductImage = try values.decodeIfPresent(String.self, forKey: .ProductImage)
		HalfPrice = try values.decodeIfPresent(String.self, forKey: .HalfPrice)
		FullPrice = try values.decodeIfPresent(String.self, forKey: .FullPrice)
		CostPrice = try values.decodeIfPresent(String.self, forKey: .CostPrice)
		SKU = try values.decodeIfPresent(String.self, forKey: .SKU)
		ProductSHORTDESCRIPTION = try values.decodeIfPresent(String.self, forKey: .ProductSHORTDESCRIPTION)
		ProductDETAIL = try values.decodeIfPresent(String.self, forKey: .ProductDETAIL)
		StoreName = try values.decodeIfPresent(String.self, forKey: .StoreName)
		RetailerId = try values.decodeIfPresent(String.self, forKey: .RetailerId)
		StoreId = try values.decodeIfPresent(String.self, forKey: .StoreId)
		ProductMediumImage = try values.decodeIfPresent(String.self, forKey: .ProductMediumImage)
		ProductIconImage = try values.decodeIfPresent(String.self, forKey: .ProductIconImage)
		productType = try values.decodeIfPresent(String.self, forKey: .productType)
	}

	
}
