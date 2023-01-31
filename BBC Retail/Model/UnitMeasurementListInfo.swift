//
//  UnitMeasurementListInfo.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 13/12/22.
//

import Foundation
class UnitMeasurementList : DropDownModel {

   
    enum CodingKeys: String, CodingKey {
        case classField = "class"
        case id = "id"
        case type = "type"
        case uoc = "uoc"
        case uocQuantity = "uoc_quantity"
        case uom = "uom"
        case uomQuantity = "uom_quantity"
        case unit_index = "unit_index"
        
        
    }
   
    required init(from decoder: Decoder) throws {
     try super.init(from: decoder)
             let values = try decoder.container(keyedBy: CodingKeys.self)
             name = try values.decodeIfPresent(String.self, forKey: .uom)
        
        
        classField = try values.decodeIfPresent(String.self, forKey: .classField)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uoc = try values.decodeIfPresent(String.self, forKey: .uoc)
        uocQuantity = try values.decodeIfPresent(String.self, forKey: .uocQuantity)
        uom = try values.decodeIfPresent(String.self, forKey: .uom)
        uomQuantity = try values.decodeIfPresent(String.self, forKey: .uomQuantity)
        
        type = try values.decodeIfPresent(String.self, forKey: .type)
        unit_index = try values.decodeIfPresent(String.self, forKey: .unit_index)
        
        
     }
    
  /*  init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        classField = try values.decodeIfPresent(String.self, forKey: .classField)
        id = try values.decodeIfPresent(String.self, forKey: .id)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        uoc = try values.decodeIfPresent(String.self, forKey: .uoc)
        uocQuantity = try values.decodeIfPresent(String.self, forKey: .uocQuantity)
        uom = try values.decodeIfPresent(String.self, forKey: .uom)
        uomQuantity = try values.decodeIfPresent(String.self, forKey: .uomQuantity)
        
        name = try values.decodeIfPresent(String.self, forKey: .type)
    }*/


}
