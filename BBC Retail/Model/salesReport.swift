//
//  salesReport.swift
//  BBC Retail
//
//  Created by Himanshu on 13/10/22.
//

import Foundation

struct SalesReport: Codable {

    let payments: [PaymentsDetail]?
    private enum CodingKeys: String, CodingKey {
        case payments = "payments"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        payments = try values.decodeIfPresent([PaymentsDetail].self, forKey: .payments)
    }
}
struct  PaymentsDetail  : Codable{
    let date: String?
    let price: String?
    let maincategory: String?
    let subCategory : String?
    let productName: String?
    let ProductQuantity: String?
    let paymentType: String?
    let orderId: String?

    private enum CodingKeys: String, CodingKey {
        case date = "date"
        case price = "price"
        case maincategory = "maincategory"
        case subCategory = "subCategory"
        case productName = "productName"
        case ProductQuantity = "ProductQuantity"
        case paymentType = "paymentType"
        case orderId = "orderId"
     }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        price = try values.decodeIfPresent(String.self, forKey: .price)
        maincategory = try values.decodeIfPresent(String.self, forKey: .maincategory)
        subCategory = try values.decodeIfPresent(String.self, forKey: .subCategory)
        productName = try values.decodeIfPresent(String.self, forKey: .productName)
        ProductQuantity = try values.decodeIfPresent(String.self, forKey: .ProductQuantity)
        paymentType = try values.decodeIfPresent(String.self, forKey: .paymentType)
        orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
    }
}
