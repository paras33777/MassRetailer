//
//  UtilityFunc.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 29/07/22.
//

import Foundation
import UIKit

func getAttrbText(simpleText:String,text:String) -> NSMutableAttributedString{

        let range = (text as NSString).range(of: String(text))
        let range1 = (text as NSString).range(of: String(simpleText))

        let attribute = NSMutableAttributedString.init(string: text)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Montserrat-SemiBold", size: 14)!, range: range)
        attribute.addAttribute(NSAttributedString.Key.font, value: UIFont.init(name: "Montserrat-Regular", size: 14)!, range: range1)
        return attribute
    }

class Utility:NSObject {
    func roundCorner(view:UIView,borderWith:CGFloat,borderColor:UIColor,cornerRadius:CGFloat)
    {
        view.layer.cornerRadius = cornerRadius
        view.clipsToBounds = true
        view.borderWidth = borderWith
        view.borderColor = borderColor
    }
}
