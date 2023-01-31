//
//  RootClass.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on April 12, 2022
//
import Foundation

struct Base: Codable {

	let status: String?
//    let status1 : Int?
	let msg: String?
	let result: Result?
    
    let result2: Result2?
  
    
    let error : String?

	private enum CodingKeys: String, CodingKey {
		case status = "status"
//        case status1 = "status"
        case error = "error"
		case msg = "msg"
		case result = "Result"
        case result2 = "result"
	   }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		
        do {
            let statusInt = try values.decodeIfPresent(Int.self, forKey: .status) ?? 0
            status = String(statusInt )
        } catch DecodingError.typeMismatch {
            status = try values.decodeIfPresent(String.self, forKey: .status) ?? ""
        }
//        status1 = try values.decodeIfPresent(Int.self, forKey: .status1) ?? 0
		msg = try values.decodeIfPresent(String.self, forKey: .msg) ?? ""
		result = try values.decodeIfPresent(Result.self, forKey: .result)
        result2 = try values.decodeIfPresent(Result2.self, forKey: .result2)
        error = try values.decodeIfPresent(String.self, forKey: .error)
	}

    }
