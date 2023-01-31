//
//  EXStoryboard.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 12/12/22.
//

import Foundation
import UIKit
extension UIStoryboard{
    func returnMain()->UIStoryboard{
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    func returnPaymentUI()->UIStoryboard{
        return UIStoryboard.init(name: "PaymentUI", bundle: nil)
    }
    func returnProductUI()->UIStoryboard{
        return UIStoryboard.init(name: "ProductUI", bundle: nil)
    }
    func returnAddDealUI()->UIStoryboard{
        return UIStoryboard.init(name: "AddDealUI", bundle: nil)
    }
    func returnUserUI()->UIStoryboard{
        return UIStoryboard.init(name: "UserUI", bundle: nil)
    }
    
    
}
