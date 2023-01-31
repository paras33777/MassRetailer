//
//  OrderList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on April 20, 2022
//
import Foundation

struct OrderList: Codable {
    
        var orderId: String?
        var totalAmount: String!
        var paymentMethod: String?
        var transactionId: String?
        var orderdate: String?
        var orderTime: String?
        var unit: String?
        var storeType: String?
        var storePaymentType: String?
        var category: String?
        var Products: String?
        var storeName: String?
        var retailerName: String?
        var userName: String?
        var userMobile: String?
        var status: String?
        var timestamp: String?
        var reason: String?
        var order_batch_id : String?
        var order_type : String?
        var orderBatchInfo :  String?
        var table_id : String?
        var sub_status : String?
        var product_type : String?
    
    init(id:String,category:String) {
        self.orderId = id
        self.category = category
    }

	private enum CodingKeys: String, CodingKey {
                case orderId = "orderId"
                case totalAmount = "totalAmount"
                case paymentMethod = "paymentMethod"
                case transactionId = "transaction_id"
                case orderdate = "orderdate"
                case orderTime = "orderTime"
                case unit = "unit"
                case storeType = "storeType"
                case storePaymentType = "storePaymentType"
                case category = "category"
                case Products = "Products"
                case storeName = "storeName"
                case retailerName = "retailerName"
                case userName = "userName"
                case userMobile = "userMobile"
                case status = "status"
                case timestamp = "timestamp"
                case reason = "reason"
                case order_batch_id = "order_batch_id"
                case order_type
                case orderBatchInfo = "orderBatchInfo"
                case table_id = "table_id"
                case sub_status = "sub_status"
                case product_type = "product_type"
	            }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
                orderId = try values.decodeIfPresent(String.self, forKey: .orderId)
                totalAmount = try values.decodeIfPresent(String.self, forKey: .totalAmount)
                paymentMethod = try values.decodeIfPresent(String.self, forKey: .paymentMethod)
                transactionId = try values.decodeIfPresent(String.self, forKey: .transactionId)
                orderdate = try values.decodeIfPresent(String.self, forKey: .orderdate)
                orderTime = try values.decodeIfPresent(String.self, forKey: .orderTime)
        
                do {
                    let unitInt = try values.decodeIfPresent(Int.self, forKey: .unit) ?? 0
                    unit = String(unitInt )
                } catch DecodingError.typeMismatch {
                    unit = try values.decodeIfPresent(String.self, forKey: .unit) ?? ""
                }
        
                storeType = try values.decodeIfPresent(String.self, forKey: .storeType)
                storePaymentType = try values.decodeIfPresent(String.self, forKey: .storePaymentType)
                category = try values.decodeIfPresent(String.self, forKey: .category)
                Products = try values.decodeIfPresent(String.self, forKey: .Products)
                storeName = try values.decodeIfPresent(String.self, forKey: .storeName)
                retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName)
                userName = try values.decodeIfPresent(String.self, forKey: .userName)
                userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
                status = try values.decodeIfPresent(String.self, forKey: .status)
                timestamp = try values.decodeIfPresent(String.self, forKey: .timestamp)
                reason = try values.decodeIfPresent(String.self, forKey: .reason)
                order_batch_id = try values.decodeIfPresent(String.self, forKey: .order_batch_id)
                order_type = try values.decodeIfPresent(String.self, forKey: .order_type)
                orderBatchInfo = try values.decodeIfPresent(String.self, forKey: .orderBatchInfo)
                table_id = try values.decodeIfPresent(String.self, forKey: .table_id)
                sub_status = try values.decodeIfPresent(String.self, forKey: .sub_status)
                product_type = try values.decodeIfPresent(String.self, forKey: .product_type)
	          }
             }











