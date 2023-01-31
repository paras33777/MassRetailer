//
//  SubSkillViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 16/01/23.
//

import UIKit
import SwiftPopup
import UIView_Shimmer
import FTIndicator
protocol SendSubSkill{
    func tableviewReload(selectedId:[String],selectedName:[String],selectedQuantity:[String],selectedPrice1:[String])
}
class SubSkillViewController:  SwiftPopup {
    var selectedId = [String]()
    var selectedName = [String]()
    var selectedQuantity = [String]()
    var selectedPrice = [String]()
      var selectedIndexPath: IndexPath =  IndexPath()
    
    
    //    MARK: - OUTLETS
        @IBOutlet weak var tableviewTax: UITableView!
        
    //    MARK: - VARIABLES'
      
         var subSkillList : [SubSkillList]?
   
    @IBOutlet weak var titleLabel: UILabel!
        
    @IBOutlet weak var OkButton: UIButton!
    
    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var textfieldQuantity: SkyFloatingLabelTextField!
    
        var delegate: SendSubSkill?
        var taxName = String()
        var come = ""
        var productId = ""
        var productDetailData: ManfacturingProductDetail?
       var id :[String] = []
        
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
          
            self.quantityView.isHidden = true
            self.textfieldQuantity.isHidden = true
            self.tableviewTax.isHidden = false
            
            
            self.textfieldQuantity.placeholder = InventoryViewControllerConstant.EnterQuantity
            textfieldQuantity.delegate = self
            
            self.getProductSubskillListAPI()
            if self.come == "edit"{
              self.geProductDetailsByID(productId: self.productId)

            }
            self.titleLabel.text = AddProductManfacturingViewControllerConstant.AddMaSelectRawMaterialterial
            OkButton.setTitle(AddProductManfacturingViewControllerConstant.Save, for: .normal)
            
     
        }
    //      MARK: - API CALLING FOR PRODUCT TAX LIST
        func getProductSubskillListAPI(){
            WebServiceManagerDeal.sharedInstance.getAllSubSkill{ productTaxList,msg, status  in
                self.isLoading = false
                    if status == "1"{
                        
                        self.subSkillList = productTaxList!
                        
                        if let subskillInfo = self.subSkillList
                        {
                            for (index,subskillInfo1) in subskillInfo.enumerated(){
                               
                                for (index1,object) in self.id.enumerated()
                                {
                                    if subskillInfo1.id == object
                                    {
                                        if self.selectedQuantity.count > index1{
                                            subskillInfo1.quantity = self.selectedQuantity[index1]
                                        }
                                    }
                                    }
                                }
                            }
                        
                        
                        self.updateNoData(message: "")
                        self.tableviewTax.reloadData()
                     }else{
                         self.subSkillList = productTaxList!
                         self.updateNoData(message: msg!)
                         self.tableviewTax.reloadData()
                    }
                }
        }
        
        //MARK: - GET ProductDetails BY ID
            func geProductDetailsByID(productId:String){
                WebServiceManagerDeal
                    .sharedInstance.getManufacturingProductsDetail(product_id: productId) {taxlist,msg, status in
                    if status == "1"{
                        self.productDetailData = taxlist
                        print(self.productDetailData!)
                        for object in self.productDetailData?.subSkillsList ?? []{
                         
                            self.selectedId = []
                            self.selectedName = []
                            self.selectedQuantity = []
                            self.selectedPrice = []
                           
                            self.id.append(object.id ?? "")
                            self.selectedQuantity.append(object.quantity ?? "")
                            self.selectedName.append(object.id ?? "")
                                self.selectedId.append(object.quantity ?? "")
                            self.selectedPrice.append(object.price ?? "")
                        }
                       
                       
                        
                        
                        self.tableviewTax.reloadData()
                    }else{
                        FTIndicator.showToastMessage(msg)
                    }
                  }
            }
        
        //MARK: ************UPDATE NO DATA FOUND
        func updateNoData(message:String){
            if self.subSkillList?.count > 0 {
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
            
            if self.quantityView.isHidden == false{
                if self.come == "edit"{
                    
                }else{
                    
                    self.quantityView.isHidden = true
                    self.tableviewTax.isHidden = false
                    self.textfieldQuantity.isHidden = true
                    
                    self.titleLabel.text = AddProductManfacturingViewControllerConstant.AddMaSelectRawMaterialterial
                    selectedId.append(self.subSkillList?[selectedIndexPath.row].id ?? "")
                    selectedName.append(self.subSkillList?[selectedIndexPath.row].name ?? "")
                    
                    selectedPrice.append(self.subSkillList?[selectedIndexPath.row].price ?? "")
                    
                    selectedQuantity.append(self.textfieldQuantity.text ?? "")
                    self.tableviewTax.reloadData()
                }
            }
            else {
                if let del = delegate{
                    self.dismiss()
                    del.tableviewReload(selectedId: self.selectedId, selectedName: self.selectedName,selectedQuantity:self.selectedQuantity,selectedPrice1:self.selectedPrice)
                }
            }
           
           
        }
        
        @IBAction func cancelButtonTapped(_ sender: UIButton) {
            self.dismiss()
        }
        
    }

    //  MARK: - EXTENSION TABLEVIEW
    extension SubSkillViewController: UITableViewDelegate,UITableViewDataSource{
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if self.isLoading == false{
                return self.subSkillList?.count ?? 0
            }else{
                return 5
            }
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableviewTax.dequeueReusableCell(withIdentifier: "ProductTaxTableviewCell", for: indexPath) as! ProductTaxTableviewCell
            cell.buttonCheck.isUserInteractionEnabled = false
            cell.QtyLabel.text = ""
            if self.isLoading == false{
                cell.labelTax.text = self.subSkillList?[indexPath.row].name ?? ""
                if self.come == "edit"{
                   
                    if self.id.contains(self.subSkillList?[indexPath.row].id ?? ""){
                        cell.buttonCheck.isSelected = true
                    }else{
                        cell.buttonCheck.isSelected = false
                    }
                     let qty = self.subSkillList?[indexPath.row].quantity ?? ""
                    if qty != ""{
                        cell.QtyLabel.text = AddProductManfacturingViewControllerConstant.Qty + qty
                    }
                   
                    
                    
                }else{
                    if self.selectedQuantity.count > indexPath.row{
                        let quantity = selectedQuantity[indexPath.row]
                        cell.QtyLabel.text = AddProductManfacturingViewControllerConstant.Qty + quantity
                    }
                    
                    if self.selectedId.contains(self.subSkillList?[indexPath.row].id ?? ""){
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
                        WebServiceManagerDeal.sharedInstance.deleteProductSubSkill(product_id: self.productId, subSkillId: self.subSkillList?[indexPath.row].id ?? ""){ msg, status in
                            if status == "1"{
                                self.id.removeAll()
                                self.subSkillList?[indexPath.row].quantity = ""
                                self.geProductDetailsByID(productId: self.productId)
                               
                            }else{
                                FTIndicator.showToastMessage(msg)
                            }
                            
                        }
                    }else{
                        WebServiceManagerDeal.sharedInstance.addProductSubSkill(product_id: self.subSkillList?[indexPath.row].id ?? "", subSkill: self.subSkillList?[indexPath.row].name ?? "", price: self.subSkillList?[indexPath.row].price ?? "", quantity: self.subSkillList?[indexPath.row].quantity ?? "") { msg, status in
                            if status == "1"{
                                self.id.removeAll()
                               
                                self.geProductDetailsByID(productId: self.productId)
                                
                               
                            }else{
                                FTIndicator.showToastMessage(msg)
                              }
                            
                            }
                        }
                    
                    self.tableviewTax.reloadData()
                }

            }else{
                self.selectedIndexPath = indexPath
                selectRecord()
            }
       }
        func selectRecord(){
        
            if selectedId.contains(self.subSkillList?[selectedIndexPath.row].id ?? ""){
                if let indexs = selectedId.firstIndex(of: self.subSkillList?[selectedIndexPath.row].id ?? "")
                {
                    
                    selectedId.remove(at:indexs)
                    selectedName.remove(at: indexs)
                    selectedQuantity.remove(at: indexs)
                    self.tableviewTax.reloadData()
                }
            }else{
             let name =   self.subSkillList?[selectedIndexPath.row].name ?? ""
                self.titleLabel.text = AddProductManfacturingViewControllerConstant.PleaseSelectQuantity
                self.quantityView.isHidden = false
                self.tableviewTax.isHidden = true
                self.textfieldQuantity.isHidden = false
                self.textfieldQuantity.text = ""
                
            }
          
        }
      
        func tableView(_ tableView: UITableView,
                                  willDisplay cell: UITableViewCell,
                                  forRowAt indexPath: IndexPath) {
            cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .lightGray)
          }
    }

extension SubSkillViewController:UITextFieldDelegate{
    
    
   
  
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        return true
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField == textfieldQuantity {
             let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
             let compSepByCharInSet = string.components(separatedBy: aSet)
             let numberFiltered = compSepByCharInSet.joined(separator: "")
             if range.location > 12 - 1 {
                 textField.text?.removeLast()
             }
             return string == numberFiltered
            
        }
        return true
    }
}
