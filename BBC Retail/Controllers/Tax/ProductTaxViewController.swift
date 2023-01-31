//
//  ProductTaxViewController.swift
//  BBC Retail
//
//  Created by Newforce MAC on 24/11/22.
//

import UIKit
import SwiftPopup
import UIView_Shimmer
import FTIndicator

protocol SendTax{
    func tableviewReload()
}

class ProductTaxTableviewCell: UITableViewCell,ShimmeringViewProtocol{

//    MARK: - OUTLETS
    @IBOutlet weak var labelTax: UILabel!
    
    @IBOutlet weak var QtyLabel: UILabel!
    
    @IBOutlet weak var buttonCheck: UIButton!
    var buttonHandler:(()->())?
    
    @IBAction func buttonTaxAction(_ sender: UIButton) {
        self.buttonHandler?()
    }
    var shimmeringAnimatedItems: [UIView] {
        [
            labelTax,
            buttonCheck
        ].compactMap({$0})
       }
    
}

class ProductTaxViewController: SwiftPopup {

//    MARK: - OUTLETS
    @IBOutlet weak var tableviewTax: UITableView!
    
//    MARK: - VARIABLES'
    var productTaxList: [ProductTaxList]?
    var delegate: SendTax?
    var taxName = String()
    var come = ""
    var productId = ""
    var productDetailData: ProductDetail?
    var id = [String]()
    
    private var isLoading = true {
         didSet {
             tableviewTax.isUserInteractionEnabled = !isLoading
             tableviewTax.reloadData()
         }
     }
    
//    MARK: - VIEW LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableviewTax.delegate = self
        self.tableviewTax.dataSource = self
        self.isLoading = true
        self.getProductTaxListAPI()
        if self.come == "edit"{
          self.geProductDetailsByID(productId: self.productId)

        }
 
    }
//      MARK: - API CALLING FOR PRODUCT TAX LIST
    func getProductTaxListAPI(){
        WebServiceManager.sharedInstance.getProductTax{ productTaxList,msg, status  in
            self.isLoading = false
                if status == "1"{
                    self.productTaxList = productTaxList!
                    self.updateNoData(message: "")
                    self.tableviewTax.reloadData()
                 }else{
                     self.productTaxList = [ProductTaxList]()
                     self.updateNoData(message: msg!)
                     self.tableviewTax.reloadData()
                }
            }
    }
    
    //MARK: - GET ProductDetails BY ID
        func geProductDetailsByID(productId:String){
            WebServiceManager.sharedInstance.getProductDetailsById(product_id: productId) {taxlist,msg, status in
                if status == "1"{
                    self.productDetailData = taxlist
                    print(self.productDetailData!)
                    for i in self.productDetailData?.taxList ?? []{
                        self.id.append(i.TAX_ID ?? "")
                    }
                    self.tableviewTax.reloadData()
                }else{
                    FTIndicator.showToastMessage(msg)
                }
              }
        }
    
    //MARK: ************UPDATE NO DATA FOUND
    func updateNoData(message:String){
        if self.productTaxList?.count > 0 {
            self.tableviewTax.backgroundView = UIView()
        }else{
            let vwNoData = ViewNoData()
            self.tableviewTax.backgroundView = vwNoData
            vwNoData.imgVw.image = UIImage(named: "noDataFound")
            vwNoData.center.x = self.view.center.x
            vwNoData.center.y =  self.view.center.y
            vwNoData.label.text = message
        }
    }
  
//      MARK: - IBACTIONS
    @IBAction func buttonOkayAction(_ sender: UIButton) {
        if let del = delegate{
            self.dismiss()
            del.tableviewReload()
        }
       
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss()
    }
    
}

//  MARK: - EXTENSION TABLEVIEW
extension ProductTaxViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isLoading == false{
            return self.productTaxList?.count ?? 0
        }else{
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableviewTax.dequeueReusableCell(withIdentifier: "ProductTaxTableviewCell", for: indexPath) as! ProductTaxTableviewCell
        if self.isLoading == false{
            cell.labelTax.text = "\(self.productTaxList?[indexPath.row].NAME ?? "") @ \(self.productTaxList?[indexPath.row].PERCENTAGE ?? "")%"
            if self.come == "edit"{
               
                if self.id.contains(self.productTaxList?[indexPath.row].ID ?? ""){
                    cell.buttonCheck.isSelected = true
                }else{
                    cell.buttonCheck.isSelected = false
                }
                
                
            }else{
                if Singleton.sharedInstance.selectedTaxId.contains(self.productTaxList?[indexPath.row].ID ?? ""){
                        cell.buttonCheck.isSelected = true
                    }else{
                        cell.buttonCheck.isSelected = false
                    }
            }
           
        }else{
            
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.come == "edit"{
            if let cell = tableviewTax.cellForRow(at: indexPath) as? ProductTaxTableviewCell {
                print(indexPath)
                if cell.buttonCheck.isSelected == true{
                    WebServiceManager.sharedInstance.deleteProductTax(product_id: self.productId, tax_id: self.productTaxList?[indexPath.row].ID ?? ""){ msg, status in
                        if status == "1"{
                            self.geProductDetailsByID(productId: self.productId)
                            self.id.removeAll()
                        }else{
                            FTIndicator.showToastMessage(msg)
                        }
                        
                    }
                }else{
                    WebServiceManager.sharedInstance.addProductTax(product_id: self.productId, tax_id: self.productTaxList?[indexPath.row].ID ?? "", tax_type:           Singleton.sharedInstance.retailerData.taxType ?? ""){ msg, status in
                        if status == "1"{
                            self.geProductDetailsByID(productId: self.productId)
                            self.id.removeAll()
                        }else{
                            FTIndicator.showToastMessage(msg)
                        }
                        
                    }
                }
                self.tableviewTax.reloadData()
            }

        }else{
            if Singleton.sharedInstance.selectedTaxId.contains(self.productTaxList?[indexPath.row].ID ?? ""){
                if let indexs = Singleton.sharedInstance.selectedTaxId.firstIndex(of: self.productTaxList?[indexPath.row].ID ?? ""){
                    Singleton.sharedInstance.selectedTaxId.remove(at:indexs)
                    Singleton.sharedInstance.selectedTaxName.remove(at: indexs)
                    
                }
                
            }else{
                Singleton.sharedInstance.selectedTaxId.append(self.productTaxList?[indexPath.row].ID ?? "")
                Singleton.sharedInstance.selectedTaxName.append("\(self.productTaxList?[indexPath.row].NAME ?? "") @ \(self.productTaxList?[indexPath.row].PERCENTAGE ?? "")%")
            }
            self.tableviewTax.reloadData()
        }
   }
  
    func tableView(_ tableView: UITableView,
                              willDisplay cell: UITableViewCell,
                              forRowAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .lightGray)
      }
}
