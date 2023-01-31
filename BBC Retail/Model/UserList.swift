//
//  UserList.swift
//
//  Generated using https://jsonmaster.github.io
//  Created on July 04, 2022
//
import Foundation

class UserList: Codable {

	let memberId: String?
	let firstname: String?
	let lastname: String?
	let email: String?
	let countryCode: String?
	let mobileNumber: String?
	let userType: String?
	let status: String?
    var isSelectUser: Bool? = false
    
    
    
    let userDialCode : String?
    let userEmail : String?
    let userFirstName : String?
    let userId : String?
    let userLastName : String?
    let userMobile : String?


	private enum CodingKeys: String, CodingKey {
		case memberId = "memberId"
		case firstname = "firstname"
		case lastname = "lastname"
		case email = "email"
		case countryCode = "countryCode"
		case mobileNumber = "mobileNumber"
		case userType = "userType"
		case status = "status"
        case isSelectUser = "isSelectUser"
        
        
               case userDialCode = "userDialCode"
                case userEmail = "userEmail"
                case userFirstName = "userFirstName"
                case userId = "userId"
                case userLastName = "userLastName"
                case userMobile = "userMobile"
       
	}

    required init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		memberId = try values.decodeIfPresent(String.self, forKey: .memberId)
		firstname = try values.decodeIfPresent(String.self, forKey: .firstname)
		lastname = try values.decodeIfPresent(String.self, forKey: .lastname)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		countryCode = try values.decodeIfPresent(String.self, forKey: .countryCode)
		mobileNumber = try values.decodeIfPresent(String.self, forKey: .mobileNumber)
		userType = try values.decodeIfPresent(String.self, forKey: .userType)
		status = try values.decodeIfPresent(String.self, forKey: .status)
     
        isSelectUser = try values.decodeIfPresent(Bool.self, forKey: .isSelectUser)
        
        
      
               
                userDialCode = try values.decodeIfPresent(String.self, forKey: .userDialCode)
                userEmail = try values.decodeIfPresent(String.self, forKey: .userEmail)
                userFirstName = try values.decodeIfPresent(String.self, forKey: .userFirstName)
                userId = try values.decodeIfPresent(String.self, forKey: .userId)
                userLastName = try values.decodeIfPresent(String.self, forKey: .userLastName)
                userMobile = try values.decodeIfPresent(String.self, forKey: .userMobile)
            


	}



}
