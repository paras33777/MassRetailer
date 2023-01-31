//
//  Headers.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 27/06/22.
//

import Foundation
import Alamofire
import FirebaseMessaging


    func getHeaders() -> HTTPHeaders{
        var accessKey : String!
        var authToken : String!
        if  Singleton.sharedInstance.retailerData != nil{
            accessKey = Singleton.sharedInstance.retailerData.accessKey ?? ""
            authToken = Singleton.sharedInstance.retailerData.accessToken ?? ""
        }else{
            accessKey = ""
            authToken = ""
        }
        let header : HTTPHeaders = ["access_key":accessKey,"auth_token":authToken]
       return header
    }
//*******PAK********//
func getHeadersOuthKey() -> HTTPHeaders{
    let header : HTTPHeaders = ["outhKey":"$^%$^*(^&%"]
   return header
}

func getHeadersLogin() -> HTTPHeaders{
    let messaging = Messaging.messaging()
    let token = messaging.fcmToken
    let header : HTTPHeaders = ["outhKey":"$^%$^*(^&%","fcm_token":token ?? ""]
   return header
}
