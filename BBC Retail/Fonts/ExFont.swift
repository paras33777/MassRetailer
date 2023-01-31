//
//  ExFont.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 08/12/22.
//

import Foundation
import UIKit
extension UIFont{
    func MontserratSemiBold(size:CGFloat) ->  UIFont{
        return UIFont.init(name: "Montserrat-SemiBold", size: size) ?? UIFont.init()
    }
    func MontserratRegular(size:CGFloat) ->  UIFont{
       return UIFont.init(name: "Montserrat-Regular", size: size) ?? UIFont.init()
    }
    func MontserratMedium(size:CGFloat) ->  UIFont{
        return  UIFont.init(name: "Montserrat-Medium", size: size) ?? UIFont.init()
    }
    func MontserratBold(size:CGFloat) ->  UIFont{
        return  UIFont.init(name: "Montserrat-Bold", size: size) ?? UIFont.init()
    }
}
