//
//  CreateForgotPassController.swift
//  Newforce Admin
//
//  Created by MAC-mini on 02/02/21.
//  Copyright © 2021 NewforceTechnologies. All rights reserved.
//

import UIKit
import FTIndicator


class ResetPassController: UIViewController {
//MARK: IBOTLET
    @IBOutlet weak var txtNewPassword: SkyFloatingLabelTextField!
    @IBOutlet weak var txtConfirmPassword: SkyFloatingLabelTextField!
    //MARK: VARIABLE
    var username = String()
//MARK: IBACTIONS
    @IBAction func btnUpdatePasswordAction(_ sender: UIButton) {
    textFieldValidations()
    }
    @IBAction func btnBackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnUnhidePasswordAction(_ sender: UIButton) {
        if sender.tag == 100{
            if txtNewPassword.isSecureTextEntry{
                sender.setImage(#imageLiteral(resourceName: "openEye"), for: .normal)
                txtNewPassword.isSecureTextEntry = false
            }else{
                sender.setImage(#imageLiteral(resourceName: "closeEye"), for: .normal)
                txtNewPassword.isSecureTextEntry = true
            }
            }else{
            if txtConfirmPassword.isSecureTextEntry{
                sender.setImage(#imageLiteral(resourceName: "openEye"), for: .normal)
                txtConfirmPassword.isSecureTextEntry = false
            }else{
                sender.setImage(#imageLiteral(resourceName: "closeEye"), for: .normal)
                txtConfirmPassword.isSecureTextEntry = true
            }
        }
    }
    
    //MARK: VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtNewPassword.setRightPaddingPoints(30)
        txtConfirmPassword.setRightPaddingPoints(30)
    }
    
  
    //MARK: ************RESET PASSWORD API FUNCTION
    func resetRetailPassword(password:String){
    showIndicator()
        WebServiceManager.sharedInstance.resetRetailerPassword(username: username, pass: password) { msg, status in
            self.hideIndicator()
            if status == "1"{
            FTIndicator.showToastMessage(msg)
                self.navigationController?.popToRootViewController(animated: true)
            }else{
            FTIndicator.showToastMessage(msg)
            }
    }
    }
    //MARK: ************TEXTFIELD VALIDATION
    func textFieldValidations(){
        do {
            let newPass = try Validation.shared.validate(type: ValidationType.password, inputValue: txtNewPassword.text!, fieldName: "new password")
            let passConfirmation = try Validation.shared.compareValidate( inputValue1: newPass, inputValue2: txtConfirmPassword.text!)
            print(passConfirmation)
            resetRetailPassword(password: newPass)
        } catch(let error) {
            let message = (error as! ValidationError).message
            FTIndicator.showToastMessage(message)
         }
       }
   
    
}
