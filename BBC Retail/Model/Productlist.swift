//
//  Productlist.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on April 20, 2022
//
import Foundation


struct Productlist: Codable {
    
	let ProductId: String?
	let ProductName: String?
	let MainCategory: String?
	let CHILDCATEGORYNAME: String?
	let ProductImage: String?
	let ProductOfferPrice: String?
	let ProductPrice: String?
	let ProductQuantity: String?
	let SKU: String?
	let ProductSHORTDESCRIPTION: String?
	let ProductDETAIL: String?
	let StoreName: String?
	let RetailerId: String?
	let Product_Medium_Image: String?
	let ProductIconImage: String?
    let courseDetail: String?
    let currency_Type: String?
    let product_status: String?
    let store_name : String?
    let MAINCATEGORYID: String?
    let CHILDCATEGORYID: String?
    let CostPrice: String?
    let StoreId: String?
    let productType: String?
    let slotDate : String?
    let packageType : String?
    let from_address : String?
    let to_address : String?
   
    var package_status: String?
    var package_price : String?
    var package_quantity : String?
    var product_unit : String?
    

    let storeId  : String?
    let productAmount : String?
    let slotId : String?
    let doctorName : String?
    let roomNumber : String?
    let appointmentDate : String?
    let appointmentTime : String?
    let slotTime : String?
    let doctorId : String?
    let roomId: String?
    
    
    let productId: String?
    let productName: String?
    let mainCategory: String?
    let productImage: String?
    let productOfferPrice: String?
    let productPrice: String?
    let productQuantity: String?
    let productShortDescription: String?
    let productDetail: String?
   
    let Retailer_Id: String?
    let cartMainid: String?
    let cartId: String?
    let totalPrice: String?
    let currencyType: String?
    let packagetype: String?
    let productTotalQuantity: String?
    let productMediumImage: String?
    let productIconImage: String?
    
    
    
    let COURSE_ID:String?
    let COURSE_NAME:String?
    let MAIN_CATEGORY_NAME:String?
    let FK_CHILD_CATEGORY_ID:String?
    let store_id:String?


	private enum CodingKeys: String, CodingKey {
		case ProductId = "Product_id"
		case ProductName = "Product_Name"
		case MainCategory = "Main_Category"
		case CHILDCATEGORYNAME = "CHILD_CATEGORY_NAME"
		case ProductImage = "Product_Image"
		case ProductOfferPrice = "Product_Offer_Price"
		case ProductPrice = "Product_Price"
		case ProductQuantity = "Product_Quantity"
		case SKU = "SKU"
		case ProductSHORTDESCRIPTION = "Product_SHORT_DESCRIPTION"
		case ProductDETAIL = "Product_DETAIL"
		case StoreName = "Store_Name"
		case RetailerId = "Retailer_Id"
		case Product_Medium_Image = "Product_Medium_Image"
		case ProductIconImage = "Product_Icon_Image"
        case courseDetail = "COURSE_DETAIL"
        case currency_Type = "Currency_Type"
        case product_status = "product_status"
        case store_name = "store_name"
        case slotTime = "slotTime"
        case from_address = "from_address"
        case to_address = "to_address"
        case slotDate = "slotDate"
            case MAINCATEGORYID = "MAIN_CATEGORY_ID"
            case CHILDCATEGORYID = "CHILD_CATEGORY_ID"
            case CostPrice = "Cost_Price"
            case StoreId = "Store_Id"
            case productType = "product_type"
        
        case package_price = "package_price"
        case package_quantity = "package_quantity"
        case product_unit = "product_unit"
        
        
 
//                case storeName = "store_name"
//                case storeId = "storeId"
//                case productAmount = "productAmount"
                case packageType = "packageType"
           case package_status = "package_status"
        
//                case doctorName = "doctorName"
//                case roomNumber = "roomNumber"
//                case appointmentDate = "appointmentDate"
//                case appointmentTime = "appointmentTime"
        
               // case storeName = "store_name"
                case storeId = "storeId"
                case productAmount = "productAmount"
                case slotId = "slot_id"
                case doctorName = "doctorName"
                case roomNumber = "roomNumber"
                case appointmentDate = "appointmentDate"
                case appointmentTime = "appointmentTime"
    
                case doctorId = "doctorId"
                case roomId = "roomId"
        
        
        case productId = "productId"
        case productName = "productName"
        case mainCategory = "mainCategory"
        case productImage = "productImage"
        case productOfferPrice = "productOfferPrice"
        case productPrice = "productPrice"
        case productQuantity = "productQuantity"
        case productShortDescription = "productShortDescription"
        case productDetail = "productDetail"
        case Retailer_Id = "RetailerId"
        case cartMainid = "cartMainid"
        case cartId = "cartId"
        case totalPrice = "totalPrice"
        case currencyType = "currencyType"
        case packagetype = "packagetype"
        case productTotalQuantity = "productTotalQuantity"
        case productMediumImage = "productMediumImage"
        case productIconImage = "productIconImage"
        
        
        case COURSE_ID = "COURSE_ID"
        case COURSE_NAME = "COURSE_NAME"
        case MAIN_CATEGORY_NAME = "MAIN_CATEGORY_NAME"
        case FK_CHILD_CATEGORY_ID = "FK_CHILD_CATEGORY_ID"
        case store_id = "store_id"
      
    }
    



	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
        product_status = try values.decodeIfPresent(String.self, forKey: .product_status)
        ProductId = try values.decodeIfPresent(String.self, forKey: .ProductId)
		ProductName = try values.decodeIfPresent(String.self, forKey: .ProductName)
		MainCategory = try values.decodeIfPresent(String.self, forKey: .MainCategory)
		CHILDCATEGORYNAME = try values.decodeIfPresent(String.self, forKey: .CHILDCATEGORYNAME)
		ProductImage = try values.decodeIfPresent(String.self, forKey: .ProductImage)
		ProductOfferPrice = try values.decodeIfPresent(String.self, forKey: .ProductOfferPrice)
		ProductPrice = try values.decodeIfPresent(String.self, forKey: .ProductPrice)
		ProductQuantity = try values.decodeIfPresent(String.self, forKey: .ProductQuantity)
        slotTime = try values.decodeIfPresent(String.self, forKey: .slotTime)
        slotDate = try values.decodeIfPresent(String.self, forKey: .slotDate)
        to_address = try values.decodeIfPresent(String.self, forKey: .to_address)
        from_address = try values.decodeIfPresent(String.self, forKey: .from_address)
		SKU = try values.decodeIfPresent(String.self, forKey: .SKU)
		ProductSHORTDESCRIPTION = try values.decodeIfPresent(String.self, forKey: .ProductSHORTDESCRIPTION)
		ProductDETAIL = try values.decodeIfPresent(String.self, forKey: .ProductSHORTDESCRIPTION) ?? ""
		StoreName = try values.decodeIfPresent(String.self, forKey: .StoreName )
		RetailerId = try values.decodeIfPresent(String.self, forKey: .RetailerId)
        Product_Medium_Image = try values.decodeIfPresent(String.self, forKey: .Product_Medium_Image)
		ProductIconImage = try values.decodeIfPresent(String.self, forKey: .ProductIconImage)
        courseDetail = try values.decodeIfPresent(String.self, forKey: .courseDetail)
        currency_Type = try values.decodeIfPresent(String.self, forKey: .currency_Type)
        store_name = try values.decodeIfPresent(String.self, forKey: .store_name)
        
        MAINCATEGORYID = try values.decodeIfPresent(String.self, forKey: .MAINCATEGORYID)
        CHILDCATEGORYID = try values.decodeIfPresent(String.self, forKey: .CHILDCATEGORYID)
        CostPrice = try values.decodeIfPresent(String.self, forKey: .CostPrice)
        StoreId = try values.decodeIfPresent(String.self, forKey: .StoreId)
        productType = try values.decodeIfPresent(String.self, forKey: .productType)
        
        packageType = try values.decodeIfPresent(String.self, forKey: .packageType)
        
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        
        do {
            productAmount = String(try values.decodeIfPresent(Int.self, forKey: .productAmount) ?? 0)
        } catch DecodingError.typeMismatch {
            productAmount = try values.decodeIfPresent(String.self, forKey: .productAmount) ?? ""
        }
        //productAmount = try values.decodeIfPresent(String.self, forKey: .productAmount)
        slotId = try values.decodeIfPresent(String.self, forKey: .slotId)
        doctorName = try values.decodeIfPresent(String.self, forKey: .doctorName)
        roomNumber = try values.decodeIfPresent(String.self, forKey: .roomNumber)
        appointmentDate = try values.decodeIfPresent(String.self, forKey: .appointmentDate)
        appointmentTime = try values.decodeIfPresent(String.self, forKey: .appointmentTime)
        doctorId = try values.decodeIfPresent(String.self, forKey: .doctorId)
        roomId = try values.decodeIfPresent(String.self, forKey: .roomId)
        
        
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        mainCategory = try values.decodeIfPresent(String.self, forKey: .mainCategory)
        productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
        productOfferPrice = try values.decodeIfPresent(String.self, forKey: .productOfferPrice)
        productPrice = try values.decodeIfPresent(String.self, forKey: .productPrice)
        productQuantity = try values.decodeIfPresent(String.self, forKey: .productQuantity)
        productShortDescription = try values.decodeIfPresent(String.self, forKey: .productShortDescription)
        productDetail = try values.decodeIfPresent(String.self, forKey: .productDetail)
        Retailer_Id = try values.decodeIfPresent(String.self, forKey: .Retailer_Id)
        cartMainid = try values.decodeIfPresent(String.self, forKey: .cartMainid)
        cartId = try values.decodeIfPresent(String.self, forKey: .cartId)
        totalPrice = try values.decodeIfPresent(String.self, forKey: .totalPrice)
        currencyType = try values.decodeIfPresent(String.self, forKey: .currencyType)
        packagetype = try values.decodeIfPresent(String.self, forKey: .packagetype)
        productTotalQuantity = try values.decodeIfPresent(String.self, forKey: .productTotalQuantity)
        productMediumImage = try values.decodeIfPresent(String.self, forKey: .productMediumImage)
        productIconImage = try values.decodeIfPresent(String.self, forKey: .productIconImage)
        
        COURSE_ID = try values.decodeIfPresent(String.self, forKey: .COURSE_ID)
        COURSE_NAME = try values.decodeIfPresent(String.self, forKey: .COURSE_NAME)
        MAIN_CATEGORY_NAME = try values.decodeIfPresent(String.self, forKey: .MAIN_CATEGORY_NAME)
        FK_CHILD_CATEGORY_ID = try values.decodeIfPresent(String.self, forKey: .FK_CHILD_CATEGORY_ID)
        store_id = try values.decodeIfPresent(String.self, forKey: .store_id)
      
        package_status = try values.decodeIfPresent(String.self, forKey: .package_status)
        package_quantity = try values.decodeIfPresent(String.self, forKey: .package_quantity)
        package_price = try values.decodeIfPresent(String.self, forKey: .package_price)
        product_unit = try values.decodeIfPresent(String.self, forKey: .product_unit)
        
        
	}

	
}
