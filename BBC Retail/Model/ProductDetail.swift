//
//  ProductDetail.swift
//  BBC Retail
//
//  Created by Newforce MAC on 07/12/22.
//

import Foundation

struct ProductDetail:Codable{
   
    var subSkillsList : [SubSkillsList]?
   
    var taxList : [TaxList]?
    
    
    
    let productIconImage : String?
        let productMediumImage : String?
        let childCategoryName : String?
        let createTime : String?
        let currencyType : String?
        let fkChildCategoryId : String?
        let fkGrandChildCategoryId : String?
        let fkMainCategoryId : String?
        let grandChildCategoryName : String?
        let mainCategoryName : String?
        let packageFlag : String?
        let packageId : String?
        let packagePrice : String?
        let packageQuantity : String?
        let productCostPrice : String?
        let productDescription : String?
        let productId : String?
        let productImage : String?
        let productName : String?
        let productOfferPrice : String?
        let productQrCode : String?
        let productQuantity : String?
        let productStandardPrice : String?
        let productStatus : String?
        let productUnit : String?
        let retailerId : String?
        let serviceGroup : String?
        let storeName : String?
        let storeType : String?
      //  let taxList : [String]?
        let unitId : String?

    let unit_priority : String?
    let unit_class : String?
    
    
    
        enum CodingKeys: String, CodingKey {
            case productIconImage = "Product_Icon_Image"
            case productMediumImage = "Product_Medium_Image"
            case childCategoryName = "child_category_name"
            case createTime = "create_time"
            case currencyType = "currency_type"
            case fkChildCategoryId = "fk_child_category_id"
            case fkGrandChildCategoryId = "fk_grand_child_category_id"
            case fkMainCategoryId = "fk_main_category_id"
            case grandChildCategoryName = "grand_child_category_name"
            case mainCategoryName = "main_category_name"
            case packageFlag = "package_flag"
            case packageId = "package_id"
            case packagePrice = "package_price"
            case packageQuantity = "package_quantity"
            case productCostPrice = "product_cost_price"
            case productDescription = "product_description"
            case productId = "product_id"
            case productImage = "product_image"
            case productName = "product_name"
            case productOfferPrice = "product_offer_price"
            case productQrCode = "product_qr_code"
            case productQuantity = "product_quantity"
            case productStandardPrice = "product_standard_price"
            case productStatus = "product_status"
            case productUnit = "product_unit"
            case retailerId = "retailer_id"
            case serviceGroup = "service_group"
            case storeName = "store_name"
            case storeType = "store_type"
            case taxList = "taxList"
            case unitId = "unit_id"
            case unit_priority = "unit_priority"
            
            case unit_class = "unit_class"
            
            case subSkillsList = "subSkillsList"
            
        }
        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            productIconImage = try values.decodeIfPresent(String.self, forKey: .productIconImage)
            productMediumImage = try values.decodeIfPresent(String.self, forKey: .productMediumImage)
            childCategoryName = try values.decodeIfPresent(String.self, forKey: .childCategoryName)
            createTime = try values.decodeIfPresent(String.self, forKey: .createTime)
            currencyType = try values.decodeIfPresent(String.self, forKey: .currencyType)
            fkChildCategoryId = try values.decodeIfPresent(String.self, forKey: .fkChildCategoryId)
            fkGrandChildCategoryId = try values.decodeIfPresent(String.self, forKey: .fkGrandChildCategoryId)
            fkMainCategoryId = try values.decodeIfPresent(String.self, forKey: .fkMainCategoryId)
            grandChildCategoryName = try values.decodeIfPresent(String.self, forKey: .grandChildCategoryName)
            mainCategoryName = try values.decodeIfPresent(String.self, forKey: .mainCategoryName)
            packageFlag = try values.decodeIfPresent(String.self, forKey: .packageFlag)
            packageId = try values.decodeIfPresent(String.self, forKey: .packageId)
            packagePrice = try values.decodeIfPresent(String.self, forKey: .packagePrice)
            packageQuantity = try values.decodeIfPresent(String.self, forKey: .packageQuantity)
            productCostPrice = try values.decodeIfPresent(String.self, forKey: .productCostPrice)
            productDescription = try values.decodeIfPresent(String.self, forKey: .productDescription)
            productId = try values.decodeIfPresent(String.self, forKey: .productId)
            productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
            productName = try values.decodeIfPresent(String.self, forKey: .productName)
            productOfferPrice = try values.decodeIfPresent(String.self, forKey: .productOfferPrice)
            productQrCode = try values.decodeIfPresent(String.self, forKey: .productQrCode)
            productQuantity = try values.decodeIfPresent(String.self, forKey: .productQuantity)
            productStandardPrice = try values.decodeIfPresent(String.self, forKey: .productStandardPrice)
            productStatus = try values.decodeIfPresent(String.self, forKey: .productStatus)
            productUnit = try values.decodeIfPresent(String.self, forKey: .productUnit)
            retailerId = try values.decodeIfPresent(String.self, forKey: .retailerId)
            serviceGroup = try values.decodeIfPresent(String.self, forKey: .serviceGroup)
            storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
            storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
            taxList = try values.decodeIfPresent([TaxList].self, forKey: .subSkillsList)
            unitId = try values.decodeIfPresent(String.self, forKey: .unitId)
            unit_priority = try values.decodeIfPresent(String.self, forKey: .unit_priority)
            
            unit_class = try values.decodeIfPresent(String.self, forKey: .unit_class)
            
            subSkillsList = try values.decodeIfPresent([SubSkillsList].self, forKey: .subSkillsList)
        }

}
struct ManfacturingProductDetail : Codable {

    let barCode : String?
    let categoryId : String?
    let categoryName : String?
    let childCategoryId : String?
    let childCategoryName : String?
    let createTime : String?
    let currencyType : String?
    let grandChildCategoryId : String?
    let grandChildCategoryName : String?
    let productAvatar : String?
    let productIconImage : String?
    let productId : String?
    let productMediumImage : String?
    let productName : String?
    let productShortDescription : String?
    let productStatus : String?
    let retailerId : String?
    let serviceGroup : String?
    let storeId : String?
    let storeName : String?
    let storeType : String?
    let subSkillsList : [SubSkillsList]?
    let version : String?


    enum CodingKeys: String, CodingKey {
        case barCode = "barCode"
        case categoryId = "categoryId"
        case categoryName = "categoryName"
        case childCategoryId = "childCategoryId"
        case childCategoryName = "childCategoryName"
        case createTime = "createTime"
        case currencyType = "currencyType"
        case grandChildCategoryId = "grandChildCategoryId"
        case grandChildCategoryName = "grandChildCategoryName"
        case productAvatar = "productAvatar"
        case productIconImage = "productIconImage"
        case productId = "productId"
        case productMediumImage = "productMediumImage"
        case productName = "productName"
        case productShortDescription = "productShortDescription"
        case productStatus = "productStatus"
        case retailerId = "retailerId"
        case serviceGroup = "serviceGroup"
        case storeId = "storeId"
        case storeName = "storeName"
        case storeType = "storeType"
        case subSkillsList = "subSkillsList"
        case version = "version"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        barCode = try values.decodeIfPresent(String.self, forKey: .barCode)
        categoryId = try values.decodeIfPresent(String.self, forKey: .categoryId)
        categoryName = try values.decodeIfPresent(String.self, forKey: .categoryName)
        childCategoryId = try values.decodeIfPresent(String.self, forKey: .childCategoryId)
        childCategoryName = try values.decodeIfPresent(String.self, forKey: .childCategoryName)
        createTime = try values.decodeIfPresent(String.self, forKey: .createTime)
        currencyType = try values.decodeIfPresent(String.self, forKey: .currencyType)
        grandChildCategoryId = try values.decodeIfPresent(String.self, forKey: .grandChildCategoryId)
        grandChildCategoryName = try values.decodeIfPresent(String.self, forKey: .grandChildCategoryName)
        productAvatar = try values.decodeIfPresent(String.self, forKey: .productAvatar)
        productIconImage = try values.decodeIfPresent(String.self, forKey: .productIconImage)
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        productMediumImage = try values.decodeIfPresent(String.self, forKey: .productMediumImage)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        productShortDescription = try values.decodeIfPresent(String.self, forKey: .productShortDescription)
        productStatus = try values.decodeIfPresent(String.self, forKey: .productStatus)
        retailerId = try values.decodeIfPresent(String.self, forKey: .retailerId)
        serviceGroup = try values.decodeIfPresent(String.self, forKey: .serviceGroup)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
        storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
        storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
        subSkillsList = try values.decodeIfPresent([SubSkillsList].self, forKey: .subSkillsList)
        version = try values.decodeIfPresent(String.self, forKey: .version)
    }


}
