//
//  productDetails.swift
//  BBC Retail
//
//  Created by Himanshu on 09/11/22.
//

import Foundation

struct ProductDetails: Codable {

    let productId: String?
    let productName: String?
    let productImage: String?
    let productOfferPrice: String?
    let productPrice : String?
    let costPrice : String?
    let productQuantity : String?
    let sku : String?
    let productShortDescription : String?
    let productDetail : String?
    let productMediumImage : String?
    let productIconImage : String?
    let storeId : String?
  


    
    private enum CodingKeys: String, CodingKey {
        case productId = "productId"
        case productName = "productName"
        case productImage = "productImage"
        case productOfferPrice = "productOfferPrice"
        case productPrice = "productPrice"
        case costPrice = "costPrice"
        case productQuantity = "productQuantity"
        case sku = "sku"
        case productShortDescription = "productShortDescription"
        case productDetail = "productDetail"
        case productMediumImage = "productMediumImage"
        case productIconImage = "productIconImage"
        case storeId = "storeId"
        
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        productId = try values.decodeIfPresent(String.self, forKey: .productId)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        productImage = try values.decodeIfPresent(String.self, forKey: .productImage)
        productOfferPrice = try values.decodeIfPresent(String.self, forKey: .productOfferPrice)
        productPrice = try values.decodeIfPresent(String.self, forKey: .productPrice)
        costPrice = try values.decodeIfPresent(String.self, forKey: .costPrice)
        productQuantity = try values.decodeIfPresent(String.self, forKey: .productQuantity)
        sku = try values.decodeIfPresent(String.self, forKey: .sku)
        productShortDescription = try values.decodeIfPresent(String.self, forKey: .productShortDescription)
        productDetail = try values.decodeIfPresent(String.self, forKey: .productDetail)
        productMediumImage = try values.decodeIfPresent(String.self, forKey: .productMediumImage)
        productIconImage = try values.decodeIfPresent(String.self, forKey: .productIconImage)
        storeId = try values.decodeIfPresent(String.self, forKey: .storeId)
       
    }
    
}


