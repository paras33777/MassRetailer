//
//  AddDealVC.swift
//  MASSAPPDEMO
//
//  Created by Sanjeet on 23/12/22.
//

import UIKit
import FTIndicator
protocol AddDealVCDelgate{
   func refreshLising()
}

class AddDealVC: BaseViewController {
    
    
    var delegate : AddDealVCDelgate?
    //MARK:- ==== OUTLETS ========
    @IBOutlet weak var coll_meterials: UICollectionView!
    @IBOutlet weak var tf_addUser: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_deliveryDate: SkyFloatingLabelTextField!
    @IBOutlet weak var txtView_desc: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_title: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_poductName: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_amount: SkyFloatingLabelTextField!
    @IBOutlet weak var tf_quantity: SkyFloatingLabelTextField!
    
    
    @IBOutlet weak var addButton: UIButton!
    var selectedUser = [UserList]()
    var productlist :Productlist?
    
    //MARK:- ====== VARIABLES ======
    let meterialsArr = ["Potein","Thiamine","Folate","Manganese"]
    var deliveyDate = UIDatePicker()
    
    var subSkill:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        self.navigationSetup()
    }
    func updateUI()
    {
        tf_addUser.placeholder = AddSalesOrderConstant.AddUser
        tf_poductName.placeholder = AddSalesOrderConstant.SaleOrderProductName
        tf_title.placeholder = AddSalesOrderConstant.SaleOrderTitle
        
        tf_amount.placeholder = AddSalesOrderConstant.SaleOrderAmount
      
        tf_quantity.placeholder = AddSalesOrderConstant.SaleOrderQuantity
        tf_deliveryDate.placeholder = AddSalesOrderConstant.SaleOrderDeliverDate
        
        addButton.setTitle(AddSalesOrderConstant.SaleOrderAdd, for: .normal)
        
        tf_addUser.font = UIFont().MontserratRegular(size: 13.0)
        tf_poductName.font = UIFont().MontserratRegular(size: 13.0)
        tf_title.font = UIFont().MontserratRegular(size: 13.0)
        tf_amount.font = UIFont().MontserratRegular(size: 13.0)
        tf_quantity.font = UIFont().MontserratRegular(size: 13.0)
        tf_deliveryDate.font = UIFont().MontserratRegular(size: 13.0)
        
        addButton.titleLabel?.font  = UIFont().MontserratSemiBold(size: 15)
        Utility().roundCorner(view: addButton, borderWith: 0.0, borderColor: self.themeRed, cornerRadius: 5.0)
        txtView_desc.text = AddSalesOrderConstant.Typehere
        txtView_desc.textColor = UIColor.lightGray
        
        
    }
    //MARK:- ========= BUTTON ACTION =========
    @IBAction func tapped_addDealBtn(_ sender: Any) {
        validationOfAddDeal()
    }
        @IBAction func tapped_backBtn(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        }
    fileprivate func navigationSetup() {
        let sideMenuButton =  self.getBackButton()
             sideMenuButton.0.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        navigationBarSetUp(navigation:self.navigationController,controller: self,titleText: AddSalesOrderConstant.AddSalesOrder,barTintcolor: self.themeRed , titleTextColor: .white,leftBarItem: [sideMenuButton.1],rightBarItem: nil, leftBarItem1: sideMenuButton.1)
    }
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
   
    func addManufacturingDeal(){
        self.showIndicator()
      
        
           let formatter = DateFormatter()
           formatter.dateFormat = "dd-MM-yyyy"
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd-MM-yyyy" //Friday, 14 Oct 2022
              let date   = formatter1.string(from: deliveyDate.date)
        
        let productID = self.productlist?.productId ?? ""
        let userId = self.selectedUser[0].userId ?? ""
        
        
        WebServiceManagerDeal
            .sharedInstance.addManufacturingDeal(title:self.tf_title.text ?? "",userId:userId,productId:productID,subSkills: self.subSkill, amount: self.tf_amount.text ?? "", quantity: self.tf_quantity.text ?? "", description: self.txtView_desc.text ?? "", deliveryDate: date) { msg, status in
                self.hideIndicator()
                if status == "1"{
                    FTIndicator.showToastMessage(msg)
                    self.delegate?.refreshLising()
                    self.navigationController?.popViewController(animated: true)
                }else{
                    FTIndicator.showToastMessage(msg)
                }
            }
        
     
    }
    
        func getSubSkillonProduct(productId:String){
            self.showIndicator()
            self.subSkill = ""
            WebServiceManagerDeal
                .sharedInstance.getSubSkillonProduct(product_id: productId) {taxlist,msg, status in
                    self.hideIndicator()
                if status == "1"{
                    self.subSkill = ""
                    for object in taxlist ?? [] {
                        if  self.subSkill == ""{
                            self.subSkill = object.id ?? ""
                        }else{
                            self.subSkill = self.subSkill + "," + (object.id ?? "")
                        }
                            
                    }
                }else{
                    FTIndicator.showToastMessage(msg)
                }
              }
        }
}

//MARK:- ==== API & DATA COLLECTION VALIDATION ====
extension AddDealVC{
    
    func validationOfAddDeal(){
        guard !(tf_addUser.text?.isEmpty)! && !(tf_addUser.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.userFieldEmpty)
            
            return
        }
        guard !(tf_title.text?.isEmpty)! && !(tf_title.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            
            FTIndicator.showToastMessage(AddSalesOrderConstant.titleFieldEmpty)
            
            return
        }
       
        guard !(tf_poductName.text?.isEmpty)! && !(tf_poductName.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.ProductNameFieldEmpty)
            
            return
        }
        guard !(self.subSkill.isEmpty)  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.MaterialEmpty)
            
            return
        }
       
        guard !(tf_amount.text?.isEmpty)! && !(tf_amount.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.AmountFieldEmpty)
            
            return
        }
        guard !(tf_deliveryDate.text?.isEmpty)! && !(tf_deliveryDate.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.DeliveryDateFieldEmpty)
            
            return
        }
        guard !(tf_quantity.text?.isEmpty)! && !(tf_quantity.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.QuantityFieldEmpty)
            
            return
        }
        
        if txtView_desc.textColor == UIColor.lightGray {
            FTIndicator.showToastMessage(AddSalesOrderConstant.DescriptionFieldEmpty)
            return
        }
        
        guard !(txtView_desc.text?.isEmpty)! && !(txtView_desc.text?.trimmingCharacters(in: .whitespaces).isEmpty)!  else {
            FTIndicator.showToastMessage(AddSalesOrderConstant.DescriptionFieldEmpty)
            return
        }
        addManufacturingDeal()
    }
    
    
}

//MARK:- TEXTVIEW & TEXT FIELD DELEGATE =====

extension AddDealVC:UITextViewDelegate,UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == tf_deliveryDate{
            deliveyDate.datePickerMode = .date
            if #available(iOS 13.4, *) {
                deliveyDate.preferredDatePickerStyle = .wheels
            }
            deliveyDate.minimumDate = Date().dayAfter
            deliveyDate.date = Date().dayAfter
            tf_deliveryDate.inputView = deliveyDate
        }
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        if textField == tf_addUser{
            if #available(iOS 13.0, *) {
                let vc = UIStoryboard().returnUserUI().instantiateViewController(identifier: "UsersListController") as!  UsersListController
                vc.isBackButton = true
                vc.isSelectUser = true
                vc.isSingleUser = true
                vc.selectedUser = selectedUser
                vc.isCustomer = true
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                let vc = UIStoryboard().returnUserUI().instantiateViewController(withIdentifier: "UsersListController") as!  UsersListController
                vc.isBackButton = true
                vc.isSelectUser = true
                vc.isSingleUser = true
                vc.selectedUser = selectedUser
                vc.isCustomer = true
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }
          
            
            return false
        }else if textField == tf_poductName{
            if #available(iOS 13.0, *) {
                let vc = UIStoryboard().returnAddDealUI().instantiateViewController(identifier: "SearchProductNameViewController") as!  SearchProductNameViewController
                vc.delegate = self
                vc.selectedProduct = self.productlist
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
                
                let vc = UIStoryboard().returnAddDealUI().instantiateViewController(withIdentifier: "SearchProductNameViewController")  as!  SearchProductNameViewController
                vc.delegate = self
                vc.selectedProduct = self.productlist
                self.navigationController?.pushViewController(vc, animated: true)
                
            }
           
            return false
            
        }
        
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        if textField == tf_deliveryDate{
            let formatter1 = DateFormatter()
            formatter1.dateFormat = "dd/MM/yyy" //Friday, 14 Oct 2022
            tf_deliveryDate.text  = formatter1.string(from: deliveyDate.date)
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
       if textField == tf_amount{
         if string == "" {
             return true
         }

        // Block multiple dot
         if (textField.text?.contains("."))! && string == "." {
             return false
         }

         // Check here decimal places
         if (textField.text?.contains("."))! {
             let limitDecimalPlace = 2
             let decimalPlace = textField.text?.components(separatedBy: ".").last
             if (decimalPlace?.count)! < limitDecimalPlace {
                 return true
             }
             else {
                 return false
             }
         }
         let aSet = NSCharacterSet(charactersIn:"0123456789.").inverted
         let compSepByCharInSet = string.components(separatedBy: aSet)
         let numberFiltered = compSepByCharInSet.joined(separator: "")
         if range.location > 12 - 1 {
             return false
             //textField.text?.removeLast()
         }
         return true
     }
        else if textField == tf_quantity {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if range.location > 12 - 1 {
                textField.text?.removeLast()
            }
            return string == numberFiltered
           
       }
        else
        {return true}
    }
    //TEXT VIEW
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
        }
        textView.textColor = UIColor.black
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty || textView.text == ""  {
            textView.text =  AddSalesOrderConstant.Typehere
            textView.textColor = UIColor.lightGray
        }else{
            textView.textColor = UIColor.black
        }
        
    }
}

// MARK:-  COLLECTION VIEW DELEGATE AND DATA SOURCE ======
extension AddDealVC:UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return   1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return meterialsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "meterialsListCell", for: indexPath) as! meterialsListCell
        cell.lbl_Name.layer.cornerRadius = 6
        cell.lbl_Name.layer.borderWidth = 1
        cell.lbl_Name.layer.borderColor = UIColor.lightGray.cgColor
        cell.lbl_Name.layer.masksToBounds = true
        
        //MARK:- TEXT WITH IMAGE SHOW IN LABEL  ***********
        let JC_String = NSMutableAttributedString(string: meterialsArr[indexPath.item]  + "  ")
        let JC_Attachment = NSTextAttachment()
        JC_Attachment.image = UIImage(named: "dropdown 2")
        let JC_img_String = NSAttributedString(attachment: JC_Attachment)
        JC_String.append(JC_img_String)
        cell.lbl_Name.attributedText =  JC_String
        return  cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let JC_String = NSMutableAttributedString(string: meterialsArr[indexPath.item] + " ")
        let JC_Attachment = NSTextAttachment()
        JC_Attachment.image = UIImage(named: "dropdown 2")
        
        let JC_img_String = NSAttributedString(attachment: JC_Attachment)
        JC_String.append(JC_img_String)
        let label = UILabel(frame: CGRect.zero)
        label.attributedText = JC_String
        label.sizeToFit()
        return CGSize(width: label.frame.width + 20, height: 40)
        
        
    }
    
}

extension AddDealVC: UsersListControllerDelegate{
    func selectedUser(selectedUsers:[UserList])
    {
        self.selectedUser = selectedUsers
            let user =  self.selectedUser[0]
              let name = "\(user.userFirstName?.capitalized ?? "") \(user.userLastName?.capitalized ?? "")"
             self.tf_addUser.text = name
        
     
        
    }
    
}
  
extension AddDealVC :SearchProductNameViewControllerDelegate{
    func selectProductdelegate(productList:Productlist){
        self.productlist = productList
        self.tf_poductName.text = self.productlist?.productName ?? ""
        self.getSubSkillonProduct(productId:self.productlist?.productId ?? "")
    }
}
