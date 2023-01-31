//
//  ExRawMaterial_AddProductManfacturingViewController.swift
//  BBC Retail
//
//  Created by Prashant Kumar on 16/01/23.
//

import Foundation

import AVFoundation
import FTIndicator
import SwiftPopup

extension AddProductManfacturingViewController{
   
    func updateUI_Raw(){
        
        self.txtMaterialName.placeholder = AddProductManfacturingViewControllerConstant.EnterMaterialName
        self.txtMaterialPrice.placeholder =  AddProductManfacturingViewControllerConstant.EnterMaterialPrice
        self.buttonAddMaterial.setTitle(AddProductManfacturingViewControllerConstant.AddMaterial, for: .normal)
        Utility().roundCorner(view: self.buttonAddMaterial, borderWith: 1.0, borderColor: self.themeRed, cornerRadius: 5.0)
    }
    //MARK: - GET Add RawMaterial
        func addRawMaterial()
       {
               WebServiceManagerDeal.sharedInstance.addProductSubSkill(subSkill: txtMaterialName.text ?? "", price: txtMaterialPrice.text ?? "") {obj,msg, status in
                   if status == "1"{
                       FTIndicator.showToastMessage(msg)
                       self.txtMaterialPrice.text = ""
                       self.txtMaterialName.text = ""
                   }else{
                       FTIndicator.showToastMessage(msg)
                   }
               }
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
    //MARK: - GET Add RawMaterial
        func getSubSkillList()
       {
               WebServiceManagerDeal.sharedInstance.getAllSubSkill() {obj,msg, status in
                   if status == "1"{
                       FTIndicator.showToastMessage(msg)
                       self.txtMaterialPrice.text = ""
                       self.txtMaterialName.text = ""
                   }else{
                       FTIndicator.showToastMessage(msg)
                   }
               }
        }
}
