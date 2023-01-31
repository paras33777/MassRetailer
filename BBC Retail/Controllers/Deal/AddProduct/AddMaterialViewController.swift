//
//  AddMaterialViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 18/01/23.
//

import UIKit
import AVFoundation
import FTIndicator
import SwiftPopup
protocol AddMaterialViewControllerDelegate{
    func reloadView()
}
class AddMaterialViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    var delegate:  AddMaterialViewControllerDelegate? =  nil
    
    @IBOutlet weak var txtMaterialName: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMaterialPrice: SkyFloatingLabelTextField!
    @IBOutlet weak var txtMaterialQutantity: SkyFloatingLabelTextField!
    @IBOutlet weak var buttonAddMaterial: UIButton!
    
    
    @IBOutlet weak var buttonCancel: UIButton!
    var productDetail : ManfacturingProductDetail?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtMaterialName.delegate = self
        txtMaterialPrice.delegate = self
        txtMaterialQutantity.delegate = self
         makeUIAddMaterialRaw()
        // Do any additional setup after loading the view.
    }
    @IBAction func addRawMaterial(_ sender: UIButton) {
        validations_addRawMaterial()
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    func makeUIAddMaterialRaw(){
        
        txtMaterialQutantity.placeholder = InventoryViewControllerConstant.EnterQuantity
        
        self.txtMaterialName.placeholder = AddProductManfacturingViewControllerConstant.EnterMaterialName
        self.txtMaterialPrice.placeholder =  AddProductManfacturingViewControllerConstant.EnterMaterialPrice
        self.buttonAddMaterial.setTitle(AddProductManfacturingViewControllerConstant.AddMaterial, for: .normal)
        self.buttonCancel.setTitle(CommonConstant.Cancel, for: .normal)
        
        
        
        Utility().roundCorner(view: self.buttonAddMaterial, borderWith: 1.0, borderColor: self.themeRed, cornerRadius: 5.0)
        Utility().roundCorner(view: self.buttonCancel, borderWith: 1.0, borderColor: self.themeRed, cornerRadius: 5.0)
        
        self.titleLabel.text =  ProductDetailManfacturingViewControllerConstant.AddMaterial
        
        self.titleLabel.font = UIFont().MontserratSemiBold(size: 15.0)
        txtMaterialName.font = UIFont().MontserratRegular(size: 13.0)
        txtMaterialPrice.font = UIFont().MontserratRegular(size: 13.0)
        buttonAddMaterial.titleLabel?.font =  UIFont().MontserratSemiBold(size: 13.0)
        buttonCancel.titleLabel?.font =  UIFont().MontserratSemiBold(size: 13.0)
    }
    //MARK: - VALIDATIONS
    func validations_addRawMaterial() {
        do {
            _ = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMaterialName.text ?? "", fieldName: txtMaterialName.placeholder ?? "")
            _ = try Validation.shared.validate(type: ValidationType.isBlank, inputValue: txtMaterialPrice.text!, fieldName: txtMaterialPrice.placeholder ?? "")
            self.addRawMaterial()
            } catch(let error){
              let message = (error as! ValidationError).message
                FTIndicator.showToastMessage(message)
            }
    }
    func addRawMaterial()
    {
        WebServiceManagerDeal.sharedInstance.addProductSubSkill(product_id: self.productDetail?.productId ?? "", subSkill: self.txtMaterialName.text ?? "", price: self.txtMaterialPrice.text ?? "", quantity: self.txtMaterialQutantity.text ?? "") { msg, status in
            if status == "1"{
                
                self.delegate?.reloadView()
                self.dismiss(animated: true)
                
               
            }else{
                FTIndicator.showToastMessage(msg)
              }
            
            }
        }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool{
        //Apply FORUM TEXTFIELDS ACTION
       return true
       }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
      if textField == txtMaterialName {
          
          let maxLength = 50
          let currentString: NSString = txtMaterialName.text as! NSString
          let newString: NSString =  currentString.replacingCharacters(in: range, with: string) as NSString

             return newString.length <= maxLength
     }else if textField == txtMaterialPrice{
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
     } else if textField == txtMaterialQutantity {
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
