//
//  UserInfo.swift
//  BBC Retail
//
//  Created by Himanshu on 09/11/22.
//

import Foundation

struct UserInfo: Codable {

    var user_id: String?
    let firstname: String?
    let lastname: String?
    let email: String?
    
    private enum CodingKeys: String, CodingKey {
        case user_id = "user_id"
        case firstname = "firstname"
        case lastname = "lastname"
        case email = "email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            let statusInt = try values.decodeIfPresent(Int.self, forKey: .user_id) ?? 0
            
            user_id = String(statusInt )
            
        } catch DecodingError.typeMismatch {
            
            do {
                user_id = try values.decodeIfPresent(String.self, forKey: .user_id) ?? ""
                
               
                
            } catch DecodingError.typeMismatch {
                
                
                
            }
           
            
        }
        firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
    }
}
