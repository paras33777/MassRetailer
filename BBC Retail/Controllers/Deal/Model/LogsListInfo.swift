//
//  LogsListInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/01/23.
//

import Foundation
struct LogsList : Codable {

    let cREATEBY : String?
    let cREATETIME : String?
    let iD : String?
    let rEFID : String?
    let rEFTYPE : String?
    let sTATUS : String?
    let sTATUSCOMMENT : String?
    let dateCreated : String?
    let retailerName : String?


    enum CodingKeys: String, CodingKey {
        case cREATEBY = "CREATE_BY"
        case cREATETIME = "CREATE_TIME"
        case iD = "ID"
        case rEFID = "REF_ID"
        case rEFTYPE = "REF_TYPE"
        case sTATUS = "STATUS"
        case sTATUSCOMMENT = "STATUS_COMMENT"
        case dateCreated = "dateCreated"
        case retailerName = "retailerName"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cREATEBY = try values.decodeIfPresent(String.self, forKey: .cREATEBY)
        cREATETIME = try values.decodeIfPresent(String.self, forKey: .cREATETIME)
        iD = try values.decodeIfPresent(String.self, forKey: .iD)
        rEFID = try values.decodeIfPresent(String.self, forKey: .rEFID)
        rEFTYPE = try values.decodeIfPresent(String.self, forKey: .rEFTYPE)
        sTATUS = try values.decodeIfPresent(String.self, forKey: .sTATUS)
        sTATUSCOMMENT = try values.decodeIfPresent(String.self, forKey: .sTATUSCOMMENT)
        dateCreated = try values.decodeIfPresent(String.self, forKey: .dateCreated)
        retailerName = try values.decodeIfPresent(String.self, forKey: .retailerName)
    }


}
