//
//  InventoryStoreViewController.swift
//  BBC Retail
//
//  Created by Newforce MAC on 01/12/22.
//

import UIKit
import SwiftPopup

protocol StoreName{
    func getstoreName(name:String,id:String)
    func storeProduct(name:String,productQty:String)
}

class InventoryStoreViewController: SwiftPopup {
    
//    MARK: - OUTLETS
    @IBOutlet weak var tableviewStore: UITableView!
    
//    MARK: - VARIABLES
    var allAdminList :[AllAdminList]?
    var productList :[Productlist]?
    var delegate: StoreName?
    var come = ""
    
//    MARK: - VIEW LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewStore.delegate = self
        self.tableviewStore.dataSource = self
    }

    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}
//  MARK: - EXTENSION TABLEVIEW
extension InventoryStoreViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.come == "storeProduct"{
            return self.productList?.count ?? 0
        }else{
            return self.allAdminList?.count ?? 0
        }
     
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewStore.dequeueReusableCell(withIdentifier: "ProductTaxTableviewCell", for: indexPath) as! ProductTaxTableviewCell
        if self.come == "storeProduct"{
            cell.labelTax.text = self.productList?[indexPath.row].COURSE_NAME ?? ""
        }else{
            cell.labelTax.text = self.allAdminList?[indexPath.row].store_name ?? ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let del = delegate{
            self.dismiss(animated: true)
            if self.come == "storeProduct"{
                del.storeProduct(name: self.productList?[indexPath.row].COURSE_NAME ?? "", productQty: self.productList?[indexPath.row].ProductQuantity ?? "")
            }else{
                del.getstoreName(name: self.allAdminList?[indexPath.row].store_name ?? "", id: self.allAdminList?[indexPath.row].id ?? "")
            }
           
        }
       
    }
  
    
}
