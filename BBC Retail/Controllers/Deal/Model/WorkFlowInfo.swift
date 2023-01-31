//
//  WorkFlowInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 09/01/23.
//

import Foundation
struct WorkFlow : Codable {
    
    let aDMINNAME : String?
    let addFrom : String?
    let assignFrst : String?
    let assignSecond : String?
    let dateone : String?
    let datesecond : String?
    let timeSecond : String?
    let timeone : String?
    let uSERNAME : String?
    let adminId : String?
    let commentone : String?
    let comments : String?
    let commentsecond : String?
    let createTime : String?
    let metaKey : String?
    let metaValue : String?
    let trackid : String?


    enum CodingKeys: String, CodingKey {
        case aDMINNAME = "ADMIN_NAME"
        case addFrom = "Add_From"
        case assignFrst = "AssignFrst"
        case assignSecond = "AssignSecond"
        case dateone = "Dateone"
        case datesecond = "Datesecond"
        case timeSecond = "TimeSecond"
        case timeone = "Timeone"
        case uSERNAME = "USER_NAME"
        case adminId = "admin_id"
        case commentone = "commentone"
        case comments = "comments"
        case commentsecond = "commentsecond"
        case createTime = "create_time"
        case metaKey = "meta_key"
        case metaValue = "meta_value"
        case trackid = "trackid"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        aDMINNAME = try values.decodeIfPresent(String.self, forKey: .aDMINNAME)
        addFrom = try values.decodeIfPresent(String.self, forKey: .addFrom)
        assignFrst = try values.decodeIfPresent(String.self, forKey: .assignFrst)
        assignSecond = try values.decodeIfPresent(String.self, forKey: .assignSecond)
        dateone = try values.decodeIfPresent(String.self, forKey: .dateone)
        datesecond = try values.decodeIfPresent(String.self, forKey: .datesecond)
        timeSecond = try values.decodeIfPresent(String.self, forKey: .timeSecond)
        timeone = try values.decodeIfPresent(String.self, forKey: .timeone)
        uSERNAME = try values.decodeIfPresent(String.self, forKey: .uSERNAME)
        adminId = try values.decodeIfPresent(String.self, forKey: .adminId)
        commentone = try values.decodeIfPresent(String.self, forKey: .commentone)
        comments = try values.decodeIfPresent(String.self, forKey: .comments)
        commentsecond = try values.decodeIfPresent(String.self, forKey: .commentsecond)
        createTime = try values.decodeIfPresent(String.self, forKey: .createTime)
        metaKey = try values.decodeIfPresent(String.self, forKey: .metaKey)
        metaValue = try values.decodeIfPresent(String.self, forKey: .metaValue)
        trackid = try values.decodeIfPresent(String.self, forKey: .trackid)
    }


}
