//
//  Singleton.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 14/04/22.
//

import UIKit

var Shared : Singleton = Singleton()
class Singleton: NSObject {
    
    var retailerData :RetailerData!
    var rediectFrom = RedirectFrom.none
    var notifData = (contentID:"",vertical:"")
    var qty = ""
    var selectedTaxId = [String]()
    var selectedTaxName = [String]()
   
    
    class var sharedInstance : Singleton {
        return Shared
    }
}

enum RedirectFrom {
    case  none
    case  orderGenerated
}
