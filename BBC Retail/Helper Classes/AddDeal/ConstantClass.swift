//
//  ConstantClass.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import Foundation
import UIKit

let appNameAlert = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? ""
let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)

//MARK:-  Deatl details Color
let DEAL_DETAIL_BTN_BOARDER_COLOR = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00)
let DEAL_DETAIL_BTN_DESLECT_BG_COLOR = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
let DEAL_DETAIL_BTN_SLECT_BG_COLOR = UIColor(red: 0.66, green: 0.14, blue: 0.13, alpha: 1.00)
let DEAL_DETAIL_BTN_DESLECT_TEXT_COLOR = UIColor(red: 0.41, green: 0.41, blue: 0.41, alpha: 1.00)
let DEAL_DETAIL_BTN_SLECT_TEXT_COLOR = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
