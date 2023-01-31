//
//  SideMenu.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 19/04/22.
//

import Foundation
import UIKit

struct SideMenu{

    let name: String?
    let imageWhite: UIImage?
   
    init(name:String,imageWhite:UIImage){
        self.name = name
        self.imageWhite = imageWhite
    }
    static func getStaticMenu(type:String,access:String) -> [SideMenu] {
        var productServiceList : SideMenu{
            if type == "product"{
          return  SideMenu(name: "Product List", imageWhite: UIImage(named: "productList")!)
            }else{
          return SideMenu(name: "Service List", imageWhite: UIImage(named: "productList")!)
            }
          }
        
        var productList : SideMenu{
          return  SideMenu(name: "Product List", imageWhite: UIImage(named: "productList")!)
          }
        
        var serviceList : SideMenu{
          return  SideMenu(name: "Service List", imageWhite: UIImage(named: "productList")!)
          }
        
        
        var cabServiceList : SideMenu{
            
          return  SideMenu(name: "Cab List", imageWhite: UIImage(named: "productList")!)
            
          }
        var addProductService : SideMenu{
                if type == "product"{
              return  SideMenu(name: "Add Product",  imageWhite: UIImage(named: "addProduct")!)
                }else{
              return SideMenu(name: "Add Service",  imageWhite: UIImage(named: "addProduct")!)
            }
        }
        var addProduct : SideMenu{
           return  SideMenu(name: "Add Product",  imageWhite: UIImage(named: "addProduct")!)
        }
        var addService : SideMenu{
            return SideMenu(name: "Add Service",  imageWhite: UIImage(named: "addProduct")!)
        }
        
        var addCabService : SideMenu{
               
              return  SideMenu(name: "Add Cab",  imageWhite: UIImage(named: "addProduct")!)
               
            
        }
        var generateOrder : SideMenu{
            if type == "product"{
               return SideMenu(name: "Generate Order", imageWhite: UIImage(named: "order")!)
            }else{
                return SideMenu(name: "", imageWhite: UIImage(named: "") ?? UIImage())
            }
        }
            
        switch access{
        case "common":
        let  sideMenu = [
            SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
            SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!)
            //SideMenu(name: "Log Out", imageWhite: UIImage(named: "logout")!,imageOrange:UIImage(named: "logout")!)
           ]
        return sideMenu
        case "manager":
            let  sideMenu = [
            SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
            SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
            addProductService,
            productServiceList,
            SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
            SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
            SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
            SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
            SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
            generateOrder
            //StorageAllocation
            ]
            
            if type == "product_service"{
                let  sideMenu1 = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                addProduct,
                productList,
                addService,
                serviceList,
                SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                generateOrder
                //StorageAllocation
                ]
                return sideMenu1
            }
            
            return sideMenu
        case "retailer":
            
            if Singleton.sharedInstance.retailerData.category == "hospital"{
                let  sideMenu = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                addProductService,
                productServiceList,
                SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                SideMenu(name: "Doctor Availability", imageWhite: UIImage(named: "doctor_icon")!)
                     
                ]
                if type == "product_service"{
                   
                    let  sideMenu1 = [
                    SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                    SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                    addProduct,
                    productList,
                    addService,
                    serviceList,
                    SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                    SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                    SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                    SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                    SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                    SideMenu(name: "Doctor Availability", imageWhite: UIImage(named: "doctor_icon")!)
                         
                    ]
                    return sideMenu1
                }
                
                return sideMenu

            }else if Singleton.sharedInstance.retailerData.category == "cab service"{
                let  sideMenu = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                addCabService,
                cabServiceList,
                SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                generateOrder
                ]
                return sideMenu
            } else{
                let  sideMenu = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                addProductService,
                productServiceList,
                SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                generateOrder
                ]
                
                if type == "product_service"{
                    let  sideMenu1 = [
                    SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                    SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                    addProduct,
                    productList,
                    addService,
                    serviceList,
                    SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                    SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                    SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                    SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                    SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                    generateOrder
                    ]
                    return sideMenu1

                }
                return sideMenu
            }
       
        case "owner":
            let  sideMenu = [
            SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
            SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
            addProductService,
            productServiceList,
            SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
            SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
            
            SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
            SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
            SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
            
            generateOrder
            ]
            if type == "product_service"{
                
                let  sideMenu1 = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                addProduct,
                productList,
                addService,
                serviceList,
                SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
                SideMenu(name: "Users", imageWhite: UIImage(named: "user")!),
                SideMenu(name: "Stores", imageWhite: UIImage(named: "stores")!),
                SideMenu(name: "Storage Allocation", imageWhite: UIImage(named: "storage1")!),
                
                generateOrder
                ]
                return sideMenu1
            }
            
            
            return sideMenu
        case "worker","chef","nurse","waiter":
            let  sideMenu = [
            SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
            SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
            SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
            SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
            ]
            return sideMenu
            
        case "doctor":
            let  sideMenu = [
            SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
            SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
            SideMenu(name: "Sales Order", imageWhite: UIImage(named: "salesorderList")!),
            SideMenu(name: "Work Order", imageWhite: UIImage(named: "salesorderList")!),
            ]
            return sideMenu
        default:
            let  sideMenu = [
                SideMenu(name: "Dashboard", imageWhite: UIImage(named: "dashboard")!),
                SideMenu(name: "QR Code",  imageWhite: UIImage(named: "qrCode")!),
                //SideMenu(name: "Log Out", imageWhite: UIImage(named: "logout")!,imageOrange:UIImage(named: "logout")!)
               ]
            return sideMenu
          }
       }
}
