//
//  DropDownModel.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 14/04/22.
//

import Foundation
import UIKit

class DropDownModel: Codable,Equatable {
    static func == (lhs: DropDownModel, rhs: DropDownModel) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String!
    var name: String!
    var doctor_id :String?
    var doctor_name :String?
    var position:String?
    var mainId: String?
    var dbname: String?
    var FKMAINCATEGORYID: String?
    var FKCHILDCATEGORYID: String?
    var FKGRANDCHILDCATEGORYID: String?
    var value: String?
    var color : String?
    var taxname: String?
    var taxid: String?
    var taxvalue: String?
    
    var classField : String?
    //let id : String?
    var type : String?
    var uoc : String?
    var uocQuantity : String?
    var uom : String?
    var uomQuantity : String?
    var unit_index : String?

    var isSelected : Bool = false

     enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case mainId = "main_id"
        case dbname = "dbname"
        case FKMAINCATEGORYID = "FK_MAIN_CATEGORY_ID"
        case FKCHILDCATEGORYID = "FK_CHILD_CATEGORY_ID"
         case FKGRANDCHILDCATEGORYID = "GRAND_CHILD_CATEGORY_ID"
         
        case value = "value"
         case color = "colours"
         case doctor_id = "doctor_id"
         case doctor_name = "doctor_name"
         case position = "position"
         case taxname = "taxname"
         case taxid = "taxid"
         case taxvalue = "taxvalue"
       
         
         
    }
    
    

    init(id: String,name: String) {
        self.id = id
        self.name = name
    }
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }

//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(RetailerData, forKey: .RetailerData)
//    }

}

//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        name = try values.decodeIfPresent(String.self, forKey: .name)
//    }

//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(RetailerData, forKey: .RetailerData)
//    }


class ServiceGroup : DropDownModel {
     init(name: String) {
         super.init(id: "", name: name)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    static func getStaticServiceGroup() -> [DropDownModel] {
        
        let  serviceGroup = [
            ServiceGroup(name: "Product"),
            ServiceGroup(name: "Service")
          ]//  ServiceGroup(name: "Both")
        return serviceGroup
      }
}

class UserStatus : DropDownModel {
     init(name: String) {
         super.init(id: "", name: name)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    static func getStaticStatus() -> [DropDownModel] {
        
        let  userStatus = [
            UserStatus(name: "Active"),
            UserStatus(name: "Inactive")
          ]
        return userStatus
      }
}
class Calender : DropDownModel {
     init(name: String) {
         super.init(id: "", name: name)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    static func getStaticStatus() -> [DropDownModel] {
        
        let  userStatus = [
            
            Calender(name: "Today"),
            Calender(name: "Weekly"),
            Calender(name: "Monthly"),
            Calender(name: "Custom")

          ]
        return userStatus
      }
}


